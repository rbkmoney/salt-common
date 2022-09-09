{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc
  - logrotate

app-admin/syslog-ng:
  pkg.installed:
    {% if grains.os == 'Gentoo' %}
    - pkgs:
      - {{ pkg.gen_atom('app-admin/syslog-ng') }}
    - require:
      - file: gentoo.portage.packages
      {{ libc.pkg_dep() }}
    {% elif grains.os_family == 'Debian' %}
    - pkgs:
        - syslog-ng-core
        - syslog-ng-mod-xml-parser
    - require:
      {{ libc.pkg_dep() }}
    {% endif %}
