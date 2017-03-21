{% set arch_conf = salt['pillar.get']('arch_conf', False) %}
{% set binutils_version = salt['pillar.get']('binutils:version', '2.26.1') %}

sys-devel/binutils:
  pkg.installed:
   - pkgs:
      - sys-devel/binutils: "{{ binutils_version }}[cxx,multitarget,nls,zlib]"
      - sys-devel/binutils-config: ">=5-r3"

eselect-binutils:
  eselect.set:
    - name: binutils
    - target: {{ arch_conf['CHOST'] }}-{{ binutils_version }}
    - require:
      - pkg: sys-devel/binutils
