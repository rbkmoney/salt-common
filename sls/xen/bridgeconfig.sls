#!pydsl
content = []

def mlchap(key, values):
  content.append(key + '="' + '''\n\t'''.join(values) + '"')

for br in __salt__['pillar.get']('xen:xenbrs', []):
  num = str(br['num'])
  name = 'xenbr' + num
  sname = 'net.' + name
  mlchap('bridge_' + name, br['ifaces'])
  mlchap('bridge_forward_delay_' + name, ("0",))
  mlchap('bridge_hello_time_' + name, ("1000",))
  mlchap('bridge_stp_state_' + name, ("1",))
  mlchap('config_' + name, br['config'])
  mlchap('rc_net_' + name + '_provide', ('!net',))
  mlchap('rc_net_' + name + '_need', br['need'])
  mlchap('rc_xendomains_use', (sname,))
  state('/etc/init.d/' + sname).file.symlink(target='net.lo').\
    require(file='set-xenbridges-conf')
  state(sname).service.running(enable=True).\
    require(file='/etc/init.d/' + sname)

state('set-xenbridges-conf').file.blockreplace(
  name='/etc/conf.d/net',
  marker_start='#-- start Salt xenbrs zone',
  marker_end='#-- end Salt xenbrs zone',
  append_if_not_found=True,
  content='\n'.join(content)+'\n')


