{% import slspath + '/map.jinja' as m %}

/etc/conf.d/clamd:
{% if grains['init'] == 'openrc' %}
  file.managed:
    - source: salt://{{ slspath }}/files/clamd-onacess.confd
    - mode: 644
    - user: root
    - group: root
{% else %}
  file.absent
{% endif %}

{{ m.conf_dir }}/clamav.conf:
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
