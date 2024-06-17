{% import 'pkg/common' as pkg %}
{% set onedir_dir = "/opt/saltstack/salt/" %}
{% if grains.get('pythonexecutable', '/usr/bin/python').startswith(onedir_dir) %}
{% set onedir = True %}
{% set pythonversion = grains['pythonversion'] %}
{% set onedir_pyslot = pythonversion[0]|string + '.' + pythonversion[1]|string %}
{% else %}
{% set onedir = False %}
{% endif %}
include:
  {% if grains.os == 'Gentoo' %}
  - python
  - gentoo.portage.packages
  {% elif grains.os_family == 'Debian' %}
  - .repo-debian
  {% endif %}
  {% if onedir %}
  - ssl.ca-certificates
  {% endif %}

# TODO: move cython to another state
app-admin/salt:
  {% if grains.os == 'Gentoo' %}
  pkg.installed:
    - refresh: False
    - pkgs:
      - {{ pkg.gen_atom('app-admin/salt') }}
      - {{ pkg.gen_atom('dev-python/dnspython') }}
      - {{ pkg.gen_atom('dev-python/slixmpp') }}
      - {{ pkg.gen_atom('dev-python/cython') }}
    - require:
      - file: gentoo.portage.packages
  {% elif grains.os_family == 'Debian' %}
  pkg.latest:
    - refresh: True
    - pkgs:
      - salt-common
      - salt-minion
      - salt-master
      - salt-syndic
      - salt-ssh
      - salt-api
      - salt-cloud
    - require:
      - file: /etc/apt/sources.list.d/salt.list
  {% endif %}
    - reload_modules: true

{% if grains.os == 'Gentoo' %}
/etc/logrotate.d/salt-common:
  file.absent

/etc/logrotate.d/salt:
{% elif grains.os_family == 'Debian' %}
/etc/logrotate.d/salt:
  file.absent

/etc/logrotate.d/salt-common:
{% endif %}
  file.managed:
    - source: salt://salt/files/salt.logrotate
    - mode: 644
    - user: root
    - group: root

{% if onedir %}
{{ onedir_dir }}/lib/python{{ onedir_pyslot }}/site-packages/certifi/cacert.pem:
  file.managed:
    - source: /etc/ssl/certs/ca-certificates.crt
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: /usr/sbin/update-ca-certificates
      - pkg: app-admin/salt

{{ onedir_dir }}/lib/python{{ onedir_pyslot }}/site-packages/pip/_vendor/certifi/cacert.pem:
  file.managed:
    - source: /etc/ssl/certs/ca-certificates.crt
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: /usr/sbin/update-ca-certificates
      - pkg: app-admin/salt
{% endif %}
