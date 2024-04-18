{% import slspath + '/map.jinja' as m %}

{% if grains['init'] == 'openrc' %}
/etc/conf.d/clamd:
  file.managed:
    - source: salt://{{ slspath }}/files/clamd-onacess.confd
    - mode: 644
    - user: root
    - group: root
{% elif grains['init'] == 'systemd' %}
/etc/conf.d/clamd:
  file.absent
{% endif %}

{{ m.conf_dir }}/{{ m.conf_name }}:
  file.managed:
    - source: salt://{{ slspath }}/files/clamd.conf.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root

{{ m.conf_dir }}/freshclam.conf:
  file.managed:
    - source: salt://{{ slspath }}/files/freshclam.conf.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root
