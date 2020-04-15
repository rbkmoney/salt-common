#!pydsl
# -*- mode: python -*-
def capkv(c, key, value):
  c.append(key + '=' + repr(value))

def capsor(c, key, value):
  capkv(c, key,
        value if isinstance(value, str)
        else value)

for guest in __salt__['pillar.get']('xen:guests', []):
  content = []
  content.append('# This file is managed by Salt')
  name = guest['name']
  capkv(content, 'name', name)
  if 'uuid' in guest:
    capkv(content, 'uuid', guest['uuid'])
  if 'seclabel' in guest:
    capkv(content, 'seclabel', guest['seclabel'])
  capkv(content, 'pvh', guest['pvh'] if 'pvh' in guest else 1)

  memory = guest['memory']
  maxmem = guest['maxmem'] if 'maxmem' in guest else memory
  capkv(content, 'memory', memory)
  if 'maxmem' in guest:
    capkv(content, 'maxmem', maxmem)
  capkv(content, 'vcpus', guest['vcpus'])
  if 'maxvcpus' in guest:
    capkv(content, 'maxvcpus', guest['maxvcpus'])
  if 'cpus' in guest:
    capsor(content, 'cpus', guest['cpus'])
  elif 'cpus_soft' in guest:
    capsor(content, 'cpus_soft', guest['cpus_soft'])
  if 'cpu_weight' in guest:
    capkv(content, 'cpu_weight', guest['cpu_weight'])
  if 'cap' in guest:
    capkv(content, 'cap', guest['cap'])

  capsor(content, 'vif', guest['vif'])
  if 'disk' in guest:
    capsor(content, 'disk', guest['disk'])
  if 'vfb' in guest:
    capsor(content, 'vfb', guest['vfb'])
  if 'vtpm' in guest:
    capsor(content, 'vtpm', guest['vtpm'])
  if 'channel' in guest:
    capsor(content, 'channel', guest['channel'])
  if 'usbctrl' in guest:
    capsor(content, 'usbctrl', guest['usbctrl'])
  if 'usbdev' in guest:
    capsor(content, 'usbdev', guest['usbdev'])
    
  capkv(content, 'on_poweroff', guest['on_poweroff'] if 'on_poweroff' in guest else 'destroy')
  capkv(content, 'on_crash', guest['on_crash'] if 'on_crash' in guest else 'destroy')
  capkv(content, 'on_reboot', guest['on_reboot'] if 'on_reboot' in guest else 'restart')
  capkv(content, 'on_watchdog', guest['on_watchdog'] if 'on_watchdog' in guest else 'restart')
  if 'nomigrate' in guest:
    capkv(content, 'nomigrate', guest['nomigrate'])

  if 'bootloader' in guest:
    capkv(content, 'bootloader', guest['bootloader'])
  if 'kernel' in guest:
    capkv(content, 'kernel', guest['kernel'])
  elif 'bootloader' not in guest:
    raise Exception('Neither kernel nor the bootloader are set')
  if 'ramdisk' in guest:
    capkv(content, 'ramdisk', guest['ramdisk'])
  if 'cmdline' in guest:
    capkv(content, 'cmdline', guest['cmdline'])
  else:
    capkv(content, 'root', guest['root'] if 'root' in guest else '/dev/xvda')
    capkv(content, 'extra', guest['extra'] if 'extra' in guest else 'raid=noautodetect quiet panic=30')
  for k,v in guest.get('extra-config', []):
    capkv(content, k, v)

  state('/etc/xen/domains/'+ name + '.cfg').file.managed(contents='\n'.join(content))
  if ('pinning' in guest
      and 'auto' in guest['pinning']
      and guest['pinning']['auto'] == __grains__['id']):
    state('/etc/xen/auto/'+ name + '.cfg').file.symlink(target='/etc/xen/domains/'+ name + '.cfg').\
      require(file='/etc/xen/domains/'+ name + '.cfg')
  else:
    state('/etc/xen/auto/'+ name + '.cfg').file.absent
