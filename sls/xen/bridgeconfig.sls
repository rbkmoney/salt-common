#!pydsl
changes = []

def mlchap(key, values):
  changes.append(key + '="' + '''\n\t'''.join(values) + '"\n')

for br in __salt__['pillar.get']('xen:xenbrs', []):
  mlchap('bridge_xenbr' + br['num'], br['ifaces'])
  mlchap('config_xenbr' + br['num'], (br['config'],))
  mlchap('config_brctl' + br['num'], (br['brctl'],))
  mlchap('rc_net_xenbr' + br['num'] + '_provide', ('!net',))
  mlchap('rc_net_xenbr' + br['num'] + '_need', (br['need'],))
  mlchap('rc_xendomains_use', ('net.xenbr' + br['num'],))
  state('/etc/init.d/net.xenbr' + br['num']).file.symlink(target='net.lo').\
    require(file='set-xenbridges-conf')
  state('net.xenbr' + br['num']).service.running(enable=True).\
    require(file='/etc/init.d/net.xenbr' + br['num'])

state('set-xenbridges-conf').file.blockreplace(
  name='/etc/conf.d/net',
  marker_start='#-- start Salt xenbrs zone',
  marker_end='#-- end Salt xenbrs zone',
  changes=content)


