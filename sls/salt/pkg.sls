{% import 'pkg/common' as pkg %}
include:
  - python.python2

# TODO: move cython to another state
cython:
  pkg.latest:
    - refresh: False
    - name: dev-python/cython

app-admin/salt:
  pkg.installed:
    - refresh: False
    - pkgs:
      - {{ pkg.gen_atom('app-admin/salt') }}
      - {{ pkg.gen_atom('dev-python/dnspython') }}
      - {{ pkg.gen_atom('dev-python/sleekxmpp') }}
    - reload_modules: true
    - require:
      - pkg: cython
      - pkg: python2
  {{ pkg.gen_portage_config('app-admin/salt', watch_in={'pkg': 'app-admin/salt'})|indent(8) }}


/etc/logrotate.d/salt:
  file.managed:
    - source: salt://salt/files/salt.logrotate
    - mode: 644
    - user: root
    - group: root
