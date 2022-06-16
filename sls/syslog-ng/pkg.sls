{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc
  - logrotate

app-admin/syslog-ng:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('app-admin/syslog-ng') }}
    - require:
      - file: gentoo.portage.packages
      {{ libc.pkg_dep() }}
