{% import 'pkg/common' as pkg %}
{% set packages = salt.pillar.get(pillar.get("pkg_root", "gentoo:portage:packages")) %}
{% set salt = packages.get('app-admin/salt') %}
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
      - app-admin/salt: "{{- pkg.getf(salt, 'version') -}}{{- pkg.getf(salt, 'use', join=True) -}}"
      - dev-python/dnspython: ">=1.16.0_pre20170831-r1"
      - dev-python/sleekxmpp: "~>=1.3.1"
    - watch:
      - portage_config: app-admin/salt
    - reload_modules: true
    - require:
      - pkg: cython
      - pkg: python2
  {{ pkg.getpc(salt)|indent(8) }}


/etc/logrotate.d/salt:
  file.managed:
    - source: salt://salt/files/salt.logrotate
    - mode: 644
    - user: root
    - group: root
