{% import 'pkg/common_vars' as pkg %}
{% set packages = pillar.get(pillar.get("pkg_root", "gentoo:portage:packages")) %}
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
      - app-admin/salt: "{{- pkg.getf(salt, 'version') -}}{{- pkg.getf(salt, 'use') -}}"
      - dev-python/dnspython: ">=1.16.0_pre20170831-r1"
      - dev-python/sleekxmpp: "~>=1.3.1"
    - watch:
      - portage_config: app-admin/salt
    - reload_modules: true
    - require:
      - pkg: cython
      - pkg: python2
  portage_config.flags:
    - accept_keywords: "{{ pkg.getf(salt, 'accept_keywords') -}}"
    - use: {{ pkg.getf(salt, 'use') }}


/etc/logrotate.d/salt:
  file.managed:
    - source: salt://salt/files/salt.logrotate
    - mode: 644
    - user: root
    - group: root
