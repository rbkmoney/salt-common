{% set package_name = 'app-admin/salt' %}
include:
  - python.python2
  - pkg.install

# TODO: move cython to another state
cython:
  pkg.latest:
    - refresh: False
    - name: dev-python/cython

extend:
  {{ package_name }}:
    pkg.installed:
      - refresh: False
      - pkgs:
        - dev-python/dnspython: ">=1.16.0_pre20170831-r1"
        - dev-python/sleekxmpp: "~>=1.3.1"
      - reload_modules: true
      - require:
        - pkg: cython
        - pkg: python2

/etc/logrotate.d/salt:
  file.managed:
    - source: salt://salt/files/salt.logrotate
    - mode: 644
    - user: root
    - group: root
