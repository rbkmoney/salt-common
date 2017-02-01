#!pydsl
content = []

def mlchap(key, values):
  content.append(key + '="' + '''\n\t'''.join(values) + '"')

for br in __salt__['pillar.get']('xen:xenbrs', []):
  num = str(br['num'])
  mlchap('bridge_xenbr' + num, br['ifaces'])
  mlchap('config_xenbr' + num, br['config'])
  mlchap('brctl_xenbr' + num, br['brctl'])
  mlchap('rc_net_xenbr' + num + '_provide', ('!net',))
  mlchap('rc_net_xenbr' + num + '_need', (br['need'],))
  mlchap('rc_xendomains_use', ('net.xenbr' + num,))
  state('/etc/init.d/net.xenbr' + num).file.symlink(target='net.lo').\
    require(file='set-xenbridges-conf')
  state('net.xenbr' + num).service.running(enable=True).\
    require(file='/etc/init.d/net.xenbr' + num)

state('set-xenbridges-conf').file.blockreplace(
  name='/etc/conf.d/net',
  marker_start='#-- start Salt xenbrs zone',
  marker_end='#-- end Salt xenbrs zone',
  append_if_not_found=True,
  content='\n'.join(content))


