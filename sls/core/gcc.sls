{% set arch_conf = salt['pillar.get']('arch_conf', False) %}
{% set gcc_version = salt['pillar.get']('gcc:version', '7.3.0-r3') %}
{% set gcc_profile = arch_conf['CHOST'] + '-' + gcc_version.split('-')[0] %}
gcc:
  pkg.installed:
    - pkgs:
      - sys-devel/gcc: '{{ gcc_version }}[graphite,vtv,go]'

gcc-profile:
  cmd.run:
    - name: gcc-config -f {{ gcc_profile }}
    - onlyif: "test \"$(gcc-config -c)\" != {{ gcc_profile }}"
    - watch:
      - pkg: gcc
