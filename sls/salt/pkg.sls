{% import 'pkg/common' as pkg %}
include:
  {% if grains.os == 'Gentoo' %}
  - python
  - gentoo.portage.packages
  {% elif grains.os_family == 'Debian' %}
  - .repo-debian
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

