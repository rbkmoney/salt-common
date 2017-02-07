#!pydsl

def capkv(c, key, values):
  c.append(key + '="' + values + '"')

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
  capkv(content, 'on_crash', guest['on_crash'] if 'on_crash' in guest else 'restart')
  capkv(content, 'on_reboot', guest['on_reboot'] if 'on_reboot' in guest else 'restart')
  capkv(content, 'boot', guest['boot'] if 'boot' in guest else 'd')
  capkv(content, 'kernel', guest['kernel'])
  capkv(content, 'root', guest['root'] if 'root' in guest else '/dev/xvda')
  capkv(content, 'extra', guest['extra'] if 'extra' in guest else 'raid=noautodetect quiet panic=30')
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
