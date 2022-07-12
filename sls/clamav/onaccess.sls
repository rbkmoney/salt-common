include:
  - .pkg
  - .svc

{% if grains.os_family == 'Debian' %}
{% set conf_dir = '/etc/clamav' %}
{% else %}
{% set conf_dir = '/etc' %}
{% endif %}

{% if grains['init'] == 'openrc' %}
/etc/conf.d/clamd:
  file.managed:
    - source: salt://clamav/files/clamd-onacess.confd
    - mode: 644
    - user: root
    - group: root
{% endif %}
{{ conf_dir }}/clamav.conf:
  file.managed:
    - source: salt://clamav/files/clamd-onacess.conf
    - mode: 644
    - user: root
    - group: root

{{ conf_dir }}/freshclam.conf:
  file.managed:
    - source: salt://clamav/files/freshclam.conf
    - mode: 644
    - user: root
    - group: root

extend:
  clamd:
    service.running:
      - watch:
        - file: {{ conf_dir }}/clamav.conf
        {% if grains['init'] == 'openrc' %}
        - file: /etc/conf.d/clamd
        {% endif %}
        - pkg: app-antivirus/clamav
