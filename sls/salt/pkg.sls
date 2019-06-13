{% set salt_version = salt['pillar.get']('salt:version', '<2018.0.0') %}
{% set salt_use = salt['pillar.get']('salt:use',
('openssl', 'portage', 'gnupg', 'mako', '-mysql', '-raet')) %}
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
      - app-admin/salt: "{{ salt_version }}[{{ ','.join(salt_use) }}]"
      - dev-python/dnspython: ">=1.16.0_pre20170831-r1"
      - dev-python/sleekxmpp: "~>=1.3.1"
    - watch:
      - portage_config: app-admin/salt
    - reload_modules: true
    - require:
      - pkg: cython
      - pkg: python2
  portage_config.flags:
    - accept_keywords:
      - ~*

/etc/logrotate.d/salt:
  file.managed:
    - source: salt://salt/files/salt.logrotate
    - mode: 644
    - user: root
    - group: root
