{% import 'pkg/common' as pkg %}
include:
  - python.python3
  - gentoo.portage.packages
  - salt.minion-config

# TODO: move cython to another state
app-admin/salt:
  pkg.installed:
    - refresh: False
    - pkgs:
      - {{ pkg.gen_atom('app-admin/salt') }}
      - {{ pkg.gen_atom('dev-python/dnspython') }}
      - {{ pkg.gen_atom('dev-python/slixmpp') }}
      - {{ pkg.gen_atom('dev-python/cython') }}
    - reload_modules: true
    - require:
      - file: gentoo.portage.packages
    - require_in:
      - file: /etc/salt/minion

/etc/logrotate.d/salt:
  file.managed:
    - source: salt://salt/files/salt.logrotate
    - mode: 644
    - user: root
    - group: root
