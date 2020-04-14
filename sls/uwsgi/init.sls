include:
  - augeas
  - gentoo.makeconf
  - python
  - uwsgi.pkg

uwsgi:
  service.running:
    - enable: True
    - watch:
      - pkg: www-servers/uwsgi
      - file: /etc/conf.d/uwsgi
      - file: /etc/uwsgi.d/

uwsgi-reload:
  service.running:
    - name: uwsgi
    - reload: True
