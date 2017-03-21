{% set arch_conf = salt['pillar.get']('arch_conf', False) %}
{% set gcc_version = salt['pillar.get']('gcc:version', '4.9.4') %}

gcc:
  pkg.installed:
    - pkgs:
      - sys-devel/gcc: '~={{ gcc_version }}[graphite,vtv,go]'

gcc-profile:
  cmd.wait:
    - name: gcc-config -f {{ arch_conf['CHOST'] + '-' + gcc_version }}
    - watch:
      - pkg: gcc
