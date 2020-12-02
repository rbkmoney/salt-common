{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

util-mpt3sas-purged:
  pkg.purged:
    - pkgs:
      - sys-block/megacli
      - sys-block/sas2ircu

util-mpt3sas:
  pkg.latest:
    - require:
      - file: gentoo.portage.packages
      - pkg: util-mpt3sas-purged
      {{ libc.pkg_dep() }}
    - pkgs:
      - {{ pkg.gen_atom('sys-block/storcli') }}
      - {{ pkg.gen_atom('sys-block/sas3ircu') }}
      - {{ pkg.gen_atom('sys-block/sas3flash') }}
