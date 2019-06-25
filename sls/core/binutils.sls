# TODO: eselect -> prune
{% set arch_conf = salt['pillar.get']('arch_conf', False) %}
{% set binutils_version = salt['pillar.get']('binutils:version', '2.31.1-r4') %}
{% set binutils_target = arch_conf['CHOST'] + '-' + binutils_version.split('-')[0] %}

sys-devel/binutils:
  pkg.installed:
   - pkgs:
      - sys-devel/binutils: "{{ binutils_version }}[cxx,multitarget]"
      - sys-devel/binutils-config: ">=5-r4"

eselect-binutils:
  eselect.set:
    - name: binutils
    - target: {{ binutils_target }}
    - require:
      - pkg: sys-devel/binutils
  cmd.run:
    - name: 'eselect binutils set {{ binutils_target }}'
    - onfail:
      - eselect: eselect-binutils
    - require:
      - pkg: sys-devel/binutils
