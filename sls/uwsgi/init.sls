# -*- mode: yaml -*-
include:
  - augeas
  - gentoo.makeconf
  - ssl.openssl
  - python
  - uwsgi.pkg

uwsgi:
  service.running:
    - enable: True
    - watch:
      - pkg: www-servers/uwsgi
      - pkg: openssl
      - pkg: python2
      - pkg: python3
      # TODO: more watch deps to restart on updates
      - file: /etc/conf.d/uwsgi
      - file: /etc/uwsgi.d/

uwsgi-reload:
  service.running:
    - name: uwsgi
    - reload: True
