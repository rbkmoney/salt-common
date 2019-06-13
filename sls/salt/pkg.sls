{% set package_name = 'app-admin/salt' %}
{% import 'pkg/common_vars' as common %}
{% set params = salt.pillar.get('gentoo:portage:packages:app-admin/salt') %}
include:
  - python.python2

# TODO: move cython to another state
cython:
  pkg.latest:
    - refresh: False
    - name: dev-python/cython

{{ package_name }}:
  pkg.installed:
    - refresh: False
    - pkgs:
      - app-admin/salt: "{{ common.get_flag(params, 'version') -}}{{- common.get_flag(params, 'use') }}"
      - dev-python/dnspython: ">=1.16.0_pre20170831-r1"
      - dev-python/sleekxmpp: "~>=1.3.1"
    - watch:
      - portage_config: {{ package_name }}
    - reload_modules: true
    - require:
      - pkg: cython
      - pkg: python2
  portage_config.flags:
    - accept_keywords: "{{ common.get_flag(params, 'accept_keywords') }}"
    - use: {{ common.get_flag(params, 'use') }}


/etc/logrotate.d/salt:
  file.managed:
    - source: salt://salt/files/salt.logrotate
    - mode: 644
    - user: root
    - group: root
