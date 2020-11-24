{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

{% if salt['grains.get']('diskless', False) %}
util-disk-purged:
  pkg.purged:
    - pkgs:
      - sys-apps/hdparm
      - sys-apps/smartmontools
{% endif %}

util-disk:
  pkg.latest:
    - require:
      - file: gentoo.portage.packages
      {% if salt['grains.get']('diskless', False) %}
      - pkg: util-disk-purged
      {% endif %}
      {{ libc.pkg_dep() }}
    - pkgs:
      - {{ pkg.gen_atom('sys-fs/ncdu') }}
      {% if not salt['grains.get']('diskless', False) %}
      - {{ pkg.gen_atom('sys-fs/e2fsprogs') }}
      - {{ pkg.gen_atom('sys-fs/xfsprogs') }}
      - {{ pkg.gen_atom('sys-apps/hdparm') }}
      - {{ pkg.gen_atom('sys-apps/smartmontools') }}
      {% endif %}
      {% if salt['grains.get']('fibrechannel', False)
      or salt['grains.get']('iscsi', False)
      or salt['grains.get']('scsi', False) %}
      - {{ pkg.gen_atom('sys-apps/sg3_utils') }}
      - {{ pkg.gen_atom('sys-apps/rescan-scsi-bus') }}
      {% endif %}
