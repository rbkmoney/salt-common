include:
  - python.python2

{% set saltversion = '2017.7.7' %}

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
      - dev-python/pycryptodome: "~>=3.4.7"
      - dev-python/dnspython: ">=1.16.0_pre20170831-r1"
      - dev-python/sleekxmpp: "~>=1.3.1"
    - reload_modules: true

app-admin/salt:
  pkg.installed:
    - refresh: False
    - version: "{{ saltversion }}"
    - watch:
      - portage_config: app-admin/salt
    - reload_modules: true
    - require:
      - pkg: cython
      - pkg: python2
      - pkg: salt-deps
  portage_config.flags:
    - name: '=app-admin/salt-{{ saltversion }}'
    - accept_keywords:
      - ~*
    - use:
      - openssl
      - portage
      - gnupg
      - mako
      - -mysql
      - "-raet"

/etc/logrotate.d/salt:
  file.managed:
    - source: salt://salt/files/salt.logrotate
    - mode: 644
    - user: root
    - group: root
