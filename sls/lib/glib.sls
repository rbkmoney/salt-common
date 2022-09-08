{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

{% set libs_packaged = salt['pillar.get']('libs:packaged', False) %}
dev-libs/glib:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-libs/glib') }}
    {% if libs_packaged %}
    - binhost: force
    {% endif %}
    - require:
      - file: gentoo.portage.packages
      {{ libc.pkg_dep() }}
