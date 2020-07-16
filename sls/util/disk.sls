include:
  - lib.glibc

{% if salt['grains.get']('diskless', False) %}
util-disk-purged:
  pkg.purged:
    - pkgs:
      - sys-apps/hdparm
      - sys-apps/smartmontools
{% endif %}

util-disk:
  pkg.latest:
      {% if salt['grains.get']('diskless', False) %}
    - require:
      - pkg: util-disk-purged
      {% endif %}
    - pkgs:
      - sys-fs/ncdu
      {% if not salt['grains.get']('diskless', False) %}
      - sys-fs/e2fsprogs
      - sys-fs/xfsprogs
      - sys-apps/hdparm
      - sys-apps/smartmontools
      {% endif %}
      {% if salt['grains.get']('fibrechannel', False)
      or salt['grains.get']('iscsi', False)
      or salt['grains.get']('scsi', False) %}
      - sys-apps/sg3_utils
      - sys-apps/rescan-scsi-bus
      {% endif %}
