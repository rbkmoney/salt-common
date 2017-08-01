# -*- mode: yaml -*-
include:
  - python.python2
  - salt.patch

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
      - dev-python/psutil: "=2.1.3"

app-admin/salt:
  pkg.installed:
    - refresh: False
    - version: "2015.8.13"
    - watch:
      - portage_config: app-admin/salt
    - require:
      - pkg: cython
      - pkg: python2
      - pkg: salt-deps
    - watch_in:
      - file: /usr/lib/python2.7/site-packages/salt/states/pkg.py
      - file: /usr/lib/python2.7/site-packages/salt/modules/ebuild.py
  portage_config.flags:
    - name: '=app-admin/salt-2015.8.13'
    - accept_keywords:
      - ~*
    - use:
      - openssl
{% if salt['grains.get']('mysql_server', False) %}
      - mysql
{% endif %}
      - mako
      - "-raet"

/etc/logrotate.d/salt:
  file.managed:
    - source: salt://salt/files/salt.logrotate
    - mode: 644
    - user: root
    - group: root
