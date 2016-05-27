{% set efi = salt['pillar.get']('efi',
  {'mountpoint': '/boot', 'device': '/dev/md1'}) %}

efi_directory:
  mount.mounted:
    - name: {{ efi['mountpoint'] }}
    - device: {{ efi['device'] }}
    - fstype: vfat
    - mkmnt: True

