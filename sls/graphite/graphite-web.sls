include:
  - python.dev-python.django-tagging
  - uwsgi

net-analyzer/graphite-web:
  pkg.installed:
    - version: '~>=0.9.13-r3[carbon,memcached,mysql]'
    - require:
      - pkg: dev-python/django-tagging

/etc/graphite-web/local_settings.py:
  file.managed:
    - source: salt://graphite/files/local_settings.py.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root

/etc/graphite-web/wsgi.py:
  file.managed:
    - source: salt://graphite/files/wsgi.py
    - mode: 644
    - user: root
    - group: root

/etc/uwsgi.d/graphite-web.xml:
  file.managed:
    - source: salt://graphite/files/uwsgi.xml.tpl
    - mode: 644
    - user: root
    - group: root
