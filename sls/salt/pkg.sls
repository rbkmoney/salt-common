{% import 'pkg/common' as pkg %}
{% set packages = salt.pillar.get(pillar.get("pkg_root", "gentoo:portage:packages")) %}
{% set salt = packages.get('app-admin/salt') %}
{% set dnspython = packages.get('dev-python/dnspython') %}
{% set sleekxmpp = packages.get('dev-python/sleekxmpp') %}
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
      - {{ pkg.i('app-admin/salt', salt) }}
      - {{ pkg.i('dev-python/dnspython', dnspython) }} 
      - {{ pkg.i('dev-python/sleekxmpp', sleekxmpp) }}
    - reload_modules: true
    - require:
      - pkg: cython
      - pkg: python2
  {{ pkg.getpc(salt, watch_in={'pkg': 'app-admin/salt'})|indent(8) }}


/etc/logrotate.d/salt:
  file.managed:
    - source: salt://salt/files/salt.logrotate
    - mode: 644
    - user: root
    - group: root
