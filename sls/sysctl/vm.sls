{% set vm = salt['pillar.get']('sysctl:vm', {}) %}

vm.swappiness:
  sysctl.present:
    - config: '/etc/sysctl.d/vm.conf'
    - value: {{ vm.get('swappiness', 0) }}

vm.zone_reclaim_mode:
  sysctl.present:
    - config: '/etc/sysctl.d/vm.conf'
    - value: {{ vm.get('zone_reclaim_mode', 0) }}

vm.vfs_cache_pressure:
  sysctl.present:
    - config: '/etc/sysctl.d/vm.conf'
    - value: {{ vm.get('vfs_cache_pressure', 100) }}

vm.dirty_bytes:
  sysctl.present:
    - config: '/etc/sysctl.d/vm.conf'
    - value: {{ vm.get('dirty_bytes', 33554432) }}

vm.dirty_background_bytes:
  sysctl.present:
    - config: '/etc/sysctl.d/vm.conf'
    - value: {{ vm.get('dirty_background_bytes', 8388608) }}

vm.min_free_kbytes:
  sysctl.present:
    - config: '/etc/sysctl.d/vm.conf'
    - value: {{ vm.get('min_free_kbytes', 131072) }}

vm.max_map_count:
  sysctl.present:
    - config: /etc/sysctl.d/max_map_count.conf
    - value: {{ vm.get('max_map_count', 262144) }}
