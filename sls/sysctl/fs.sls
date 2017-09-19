{% set fs = salt['pillar.get']('sysctl:fs', {}) %}

fs.file-max:
  sysctl.present:
    - config: '/etc/sysctl.d/fs.conf'
    - value: {{ fs.get('file-max', 1000000) }}

fs.inotify.max_user_watches:
  sysctl.present:
    - config: '/etc/sysctl.d/fs.conf'
    - value: {{ fs.get('inotify.max_user_watches', 100000) }}
