{% import 'pkg/common' as pkg %}
include:
  - logrotate

pkg_syslog-ng:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('app-admin/syslog-ng') }}
