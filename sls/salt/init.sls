# -*- mode: yaml -*-
include:
  - python.python2

# TODO: move cython to another state
cython:
  pkg.latest:
    - refresh: False
    - name: dev-python/cython

salt-deps:
  pkg.installed:
    - refresh: False
    - pkgs:
      - net-libs/zeromq: ">=4.1.4"
      - dev-python/pyzmq: ">=14.4"
      - dev-python/pyopenssl: ">=0.15.1"
      - dev-python/psutil: ">=5.2.2"

app-admin/salt:
  pkg.installed:
    - refresh: False
    - version: "2017.7.2"
    - watch:
      - portage_config: app-admin/salt
    - require:
      - pkg: cython
      - pkg: python2
      - pkg: salt-deps
  portage_config.flags:
    - name: '=app-admin/salt-2017.7.2'
    - accept_keywords:
      - ~*
    - use:
      - openssl
      - mako
      - -mysql
      - "-raet"

/etc/logrotate.d/salt:
  file.managed:
    - source: salt://salt/files/salt.logrotate
    - mode: 644
    - user: root
    - group: root
