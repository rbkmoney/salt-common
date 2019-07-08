# TODO: перенести флаги в gpp
qemu:
  pkg.installed:
    - pkgs:
      - app-emulation/qemu:
          "[{% if salt['grains.get']('virtual_subtype', '') == 'Xen Dom0' %}xen,{% endif -%}
          numa,nfs,xfs,rbd]"
