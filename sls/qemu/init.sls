include:
  - augeas.lenses

qemu:
  pkg.installed:
    - pkgs:
      - app-emulation/qemu:
          "[{% if salt['grains.get']('virtual_subtype', '') == 'Xen Dom0' %}xen,{% endif -%}
          numa,nfs,xfs,rbd]"
