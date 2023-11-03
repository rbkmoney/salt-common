{% import 'lib/libc.sls' as libc %}
include:
  - .pkg
  - .service

extend:
  apcupsd:
    service.running:
    - watch:
      - pkg: sys-power/apcupsd
      {{ libc.pkg_dep() }}
