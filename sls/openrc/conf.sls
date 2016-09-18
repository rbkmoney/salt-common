include:
  - augeas.lenses

manage-rc-conf:
  augeas.change:
    - name: /etc/rc.conf
    - changes:
      - set rc_parallel {{ 'YES' if salt['pillar.get']('rc:parallel', True) else 'NO' }}
      - set rc_logger YES
      - set rc_log_path /var/log/rc.log
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
