{% set arch_conf = salt['pillar.get']('arch_conf', False) %}
{% set gcc_version = salt['pillar.get']('gcc:version', '8.2.0-r6') %}
{% set gcc_profile = arch_conf['CHOST'] + '-' + gcc_version.split('-')[0] %}
sys-devel/gcc-config:
  pkg.latest

sys-devel/gcc:
  pkg.installed:
    - version: '{{ gcc_version }}[graphite,vtv,go]'

set-gcc-profile:
  cmd.run:
    - name: gcc-config -f {{ gcc_profile }}
    - onlyif: "test \"$(gcc-config -c)\" != {{ gcc_profile }}"
    - watch:
      - pkg: sys-devel/gcc
      - pkg: sys-devel/gcc-config
