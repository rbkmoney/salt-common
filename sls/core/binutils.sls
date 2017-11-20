{% set arch_conf = salt['pillar.get']('arch_conf', False) %}
{% set binutils_version = salt['pillar.get']('binutils:version', '2.29.1-r1') %}
{% set binutils_target = arch_conf['CHOST'] + '-' + binutils_version.split('-')[0] %}

sys-devel/binutils:
  pkg.installed:
   - pkgs:
      - sys-devel/binutils: "{{ binutils_version }}[cxx,multitarget]"
      - sys-devel/binutils-config: ">=5-r3"

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
