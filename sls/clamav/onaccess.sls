include:
  - .pkg
  - .svc
  
{% if grains['init'] == 'openrc' %}
/etc/conf.d/clamd:
  file.managed:
    - source: salt://clamav/files/clamd-onacess.confd
    - mode: 644
    - user: root
    - group: root
{% endif %}
/etc/clamav.conf:
  file.managed:
    - source: salt://clamav/files/clamd-onacess.conf
    - mode: 644
    - user: root
    - group: root

/etc/freshclam.conf:
  file.managed:
    - source: salt://clamav/files/freshclam.conf
    - mode: 644
    - user: root
    - group: root

extend:
  clamd:
    service.running:
      - watch:
        - file: /etc/clamav.conf
        {% if grains['init'] == 'openrc' %}
        - file: /etc/conf.d/clamd
        {% endif %}
        - pkg: app-antivirus/clamav
