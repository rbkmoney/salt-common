
{% if grains['init'] == 'openrc' %}
/etc/conf.d/uwsgi:
  file.managed:
    - source: salt://{{ slspath }}/files/uwsgi.confd
    - template: jinja
    - mode: 755
    - user: root
    - group: root
    - watch_in:
      - service: uwsgi
{% elif grains['init'] == 'systemd' %}
# /etc/systemd/system/uwsgi.service.d/override.conf:
#   file.managed:
#     - source: salt://{{ slspath }}/files/uwsgi.service.tpl
#     - template: jinja
#     - mode: 644
#     - user: root
#     - group: root
#     - makedirs: True
#     - watch_in:
#       - service: uwsgi

/etc/conf.d/uwsgi: file.absent
{% endif %}

/etc/uwsgi.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

uwsgi:
  service.running:
    {% if grains.os_family == 'Debian' %}
    - name: uwsgi-emperor
    {% endif %}
    - enable: True
    - watch:
      - file: /etc/uwsgi.d/

uwsgi-reload:
  service.running:
    {% if grains.os_family == 'Debian' %}
    - name: uwsgi-emperor
    {% else %}
    - name: uwsgi
    {% endif %}
    - reload: True
