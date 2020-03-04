include:
  - augeas.lenses

{% set rc_conf = salt['pillar.get']('rc:conf', {}) %}

manage-rc-conf:
  augeas.change:
    - name: /etc/rc.conf
    - context: /files/etc/rc.conf
    - changes:
      - set rc_parallel {{ 'YES' if rc_conf.get('parallel', True) else 'NO' }}
      - set rc_controller_cgroups "YES"
      - set rc_logger {{ 'YES' if rc_conf.get('logger', True) else 'NO' }}
      - set rc_log_path {{ rc_conf.get('log_path', '/var/log/rc.log') }}
      - set rc_crashed_start {{ 'YES' if rc_conf.get('crashed_start', True) else 'NO' }}
      - set rc_crashed_stop {{ 'YES' if rc_conf.get('crashed_stop', False) else 'NO' }}
      {% if salt['grains.get']('hwclass', False) == 'container' %}
      {% set container_type = salt['grains.get']('container_type', False) %}
      {% if container_type == 'docker' %}
      - set rc_sys docker
      {% elif container_type == 'rkt' %}
      - set rc_sys rkt
      {% endif %}
      {% elif grains['virtual'] %}
      {% if salt['grains.get']('virtual_subtype', False) == 'Xen DomU' %}
      - set rc_sys xenU
      {% elif salt['grains.get']('virtual_subtype', False) == 'Xen Dom0' %}
      - set rc_sys xen0
      {% endif %}
      {% else %}
      - set rc_sys ''
      {% endif %}
