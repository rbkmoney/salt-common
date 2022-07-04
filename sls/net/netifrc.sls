#!pyobjects
# -*- mode: python -*-

from collections import OrderedDict

netpref = '/etc/init.d/net.'
def render_kv(key, values):
  return ('_'.join(key) + '="'
          + ('''\n\t'''.join(values) if isinstance(values, list) else values)
          + '"')

def add_rc_deps(cname, c, d):
    if 'rc-use' in d:
      c[('rc', 'net', cname, 'use')] = d['rc-use']
    if 'rc-need' in d:
      c[('rc', 'net', cname, 'need')] = d['rc-need']
    if 'rc-provide' in d:
      c[('rc', 'net', cname, 'provide')] = d['rc-provide']
    if 'rc-used-by' in d:
      rc_used_by = d['rc_used_by']
      if isinstance(rc_used_by, list):
        for s in rc_used_by:
          c[('rc', s, 'use')] = 'net.'+cname
      else:
        c[('rc', rc_used_by, 'use')] = 'net.'+cname
    if 'rc-needed-by' in d:
      rc_needed_by = d['rc_needed_by']
      if isinstance(rc_needed_by, list):
        for s in rc_needed_by:
          c[('rc', s, 'need')] = 'net.'+cname
      else:
        c[('rc', rc_needed_by, 'need')] = 'net.'+cname
    return True

def render_config(header, data):
  ret = '\n'.join(header) + '\n'
  for name, d in data.items():
    ret += '# ' + name + '\n'
    for k, v in d.items():
      ret += render_kv(k, v) + '\n'
    ret += '\n'
  return ret

netifrc_config = pillar('netifrc:config')
header = ['# -*- mode: conf -*-', '# Managed by Salt']
config = OrderedDict()

if 'interfaces' in netifrc_config:
  for name, d in netifrc_config['interfaces'].items():
    c = OrderedDict()
    if 'ifname' in d:
      ifname = d['ifname']
      c[(ifname, 'name')] = name
    else:
      ifname = name
    name_rc = name.replace('-', '_')
    if 'modules' in d:
      c[('modules', name_rc)] = ' '.join(d['modules'])
    c[('config', name_rc)] = d.get('config', 'null')
    if 'routes' in d:
      c[('routes', name_rc)] = d['routes']
    if 'mtu' in d:
      c[('mtu', name_rc)] = str(d['mtu'])

    add_rc_deps(name_rc, c, d)
    config[name] = c

    File.symlink(netpref + name, target='net.lo',
                 require=[File('netifrc-conf')])
    Service.running('net.' + name, enable=True, require=[
      File('netifrc-conf'), File(netpref + name)])

if 'bonds' in netifrc_config:
  for name, d in netifrc_config['bonds'].items():
    c = OrderedDict()
    if 'ifname' in d:
      ifname = d['ifname']
      c[(ifname, 'name')] = name
    else:
      ifname = name
    name_rc = name.replace('-', '_')
    slaves = d['slaves']
    c[('slaves', name_rc)] = ' '.join(slaves)
    c[('mode', name_rc)] = d.get('mode', '802.3ad')
    c[('config', name_rc)] = d.get('config', 'null')
    if 'routes' in d:
      c[('routes', name_rc)] = d['routes']
    if 'mtu' in d:
      c[('mtu', name_rc)] = str(d['mtu'])

    c[('rc', 'net', name_rc, 'need')] = ' '.join(['net.'+s for s in slaves])  
    add_rc_deps(name_rc, c, d)

    for slave in slaves:
      if not slave in netifrc_config.get('interfaces', {}):
        cs = OrderedDict()
        cs[('config', slave)] = 'null'
        cs[('modules', slave)] = '!netplug'
        cs[('rc_net', slave, 'provide')] = '!net'
        config[slave] = cs
        File.symlink(netpref + slave, target='net.lo',
                     require=[File('netifrc-conf')])
        Service.running('net.' + slave, enable=True, require=[
          File('netifrc-conf'), File(netpref + slave)])

    config[name] = c

    File.symlink(netpref + name, target='net.lo',
                 require=[File('netifrc-conf')])
    Service.running('net.' + name, enable=True, require=[
      File('netifrc-conf'), File(netpref + name)])

if 'vlans' in netifrc_config:
  for name, d in netifrc_config['vlans'].items():
    name_rc = name.replace('-', '_')
    _id = str(d['id'])
    link = d['link']
    ifname = 'vlan'+ _id
    gvrp_on = 'on' if d.get('gvrp', True) else 'off'
    loose_binding_on = 'on' if d.get('loose_binding', True) else 'off'
    flags = ' '.join(('gvrp', gvrp_on , 'loose_binding', loose_binding_on))

    c = OrderedDict()
    c[(ifname, 'name')] = name
    c[(ifname, 'flags')] = flags
    c[('config', name_rc)] = d.get('config', 'null')
    if 'routes' in d:
      c[('routes', name_rc)] = d['routes']
    if 'mtu' in d:
      c[('mtu', name_rc)] = str(d['mtu'])

    c[('rc', 'net', name_rc, 'need')] = 'net.'+link
    add_rc_deps(name_rc, c, d)
    config[name] = c
    # TODO: interface renaming logic?
    if ('vlans', link) in config[link]:
      config[link][('vlans', link)].append(_id)
    else: config[link][('vlans', link)] = [_id]

    Cmd.run('add-vlan'+_id+'-on-'+d['link']+'-if-not-exists',
            name=' '.join(('ip link add link', link, 'name', name,
                           'type vlan id', _id, flags)),
            unless='ip link show '+ name)

    File.symlink(netpref + name, target='net.lo',
                 require=[File('netifrc-conf')])
    Service.running('net.' + name, enable=True, require=[
      File('netifrc-conf'), File(netpref + name),
      Cmd('add-vlan'+_id+'-on-'+link+'-if-not-exists')])

if 'bridges' in netifrc_config:
  for name, d in netifrc_config['bridges'].items():
    name_rc = name.replace('-', '_')
    ifaces = d.get('interfaces', [])

    c = OrderedDict()
    c[('bridge', name_rc)] = ifaces
    c[('bridge_forward_delay', name_rc)] = str(d.get('forward-delay', 0))
    c[('bridge_hello_time', name_rc)] = str(d.get('hello-time', 1000))
    c[('bridge_stp_state', name_rc)] = str(d.get('stp-state', 1))
    c[('config', name_rc)] = d.get('config', 'null')
    if 'routes' in d:
      c[('routes', name_rc)] = d['routes']
    if 'mtu' in d:
      c[('mtu', name_rc)] = str(d['mtu'])

    if ifaces:
      c[('rc', 'net', name_rc, 'need')] = ['net.'+l for l in ifaces]
    add_rc_deps(name_rc, c, d)
    config[name] = c

    File.symlink(netpref + name, target='net.lo',
                 require=[File('netifrc-conf')])
    Service.running('net.' + name, enable=True, require=[
      File('netifrc-conf'), File(netpref + name)])
    
File.managed('netifrc-conf',
  name='/etc/conf.d/net',
  contents=render_config(header, config))
