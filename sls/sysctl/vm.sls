#!pyobjects

p_vm = pillar('sysctl:vm', {})
defaults = {
  # Swap
  'swappiness': 0,
  # NUMA
  'zone_reclaim_mode': 0,
  # Buf/cache
  'dirty_bytes': 33554432,
  'dirty_background_bytes': 8388608,
  'max_map_count': 262144,
  'vfs_cache_pressure': 100,
  # OOM
  'min_free_kbytes': 131072,
}

for k, v in defaults.items():
  if not k in p_vm:
    p_vm[k] = v

def walk(path, data, conf_path='/etc/sysctl.d/vm.conf'):
  for key, value in data.items():
    if isinstance(value, dict):
      walk(path + '.' + key, value, conf_path)
    else:
      Sysctl.present(path + '.' + key, config=conf_path, value=str(value))

walk('vm', p_vm)
