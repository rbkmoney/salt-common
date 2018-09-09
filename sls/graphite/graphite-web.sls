{% set uwsgi_conf = salt['pillar.get']('graphite-web:uwsgi', {}) %}
{% set uwsgi_plugins = uwsgi_conf.get('plugins', 'python36') %}
{% set uwsgi_processes = uwsgi_conf.get('processes', salt['grains.get']('num_cpus', 2)) %}
include:
  - python.dev-python.django-tagging
  - uwsgi

net-analyzer/graphite-web:
  pkg.installed:
    - version: '~>=1.1.3-r1[carbon,memcached,mysql]'
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

/etc/uwsgi.d/graphite-web.ini:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - contents: |
        [uwsgi]
        plugins={{ uwsgi_plugins }}
        master=true
        single-interpreter=true
        processes={{ uwsgi_processes }}
        harakiri=120
        post-buffering=8192
        post-buffering-bufsize=65536
        socket=/run/%n.sock
        # TODO: take number of processes from some variable
        chown-socket=nginx:nginx
        chmod-socket=640
        user=carbon
        uid=carbon
        chdir=/etc/%n
        env=DJANGO_SETTINGS_MODULE=graphite.settings
        module=wsgi
