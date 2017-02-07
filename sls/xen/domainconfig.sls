#!pydsl

def capkv(c, key, values):
  c.append(key + '="' + '''\n\t'''.join(values) + '"')

for guest in __salt__['pillar.get']('xen:guests', []):
  content = []
  content.append('# This file is managed by Salt')
  name = guest['name']
  capkv(content, 'name', name)
  if 'uuid' in guest:
    capkv(content, 'name', guest['uuid'])    
  else:
    content.append('# uuid = "genme"')
  memory = guest['memory']
  maxmem = guest['maxmem'] if 'maxmem' in guest else memory
  capkv(content, 'memory', memory)
  capkv(content, 'maxmem', maxmem)
  capkv(content, 'vcpus', guest['vcpus'])
  content.append('vif = ' + repr(guest['vifs']))
  content.append('disk = ' + repr(guest['disks']))
  capkv(content, 'on_crash', )
  capkv(content, 'on_reboot', )
  capkv(content, 'boot', )
  capkv(content, 'kernel', )
  capkv(content, 'root', )
  capkv(content, 'extra', )
  for k,v in guest.get('extra-config', []):
    capkv(content, k, v)
  state('/etc/xen/domains/'+ name + '.cfg').file.managed(content=content)
  if ('pinning' in guest
      and 'auto' in guest['pinning']
      and guest['pinning']['auto'] == __grains__['id']):
    state('/etc/xen/auto/'+ name + '.cfg').file.symlink(target='/etc/xen/domains/'+ name + '.cfg').\
      require(file='/etc/xen/domains/'+ name + '.cfg')
  else:
    state('/etc/xen/auto/'+ name + '.cfg').file.absent
