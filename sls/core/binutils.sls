{% import 'pkg/common' as pkg %}
{% set arch_conf = salt.pillar.get('arch_conf') %}
{% set binutils_version = salt.pillar.get('gentoo:portage:packages:sys-devel/binutils:version') %}
{% set binutils_target = arch_conf['CHOST'] + '-' + binutils_version.split('-')[0] %}

sys-devel/binutils:
  pkg.installed:
   - pkgs:
      - {{ pkg.gen_atom('sys-devel/binutils') }}
      - {{ pkg.gen_atom('sys-devel/binutils-config') }}
  {{ pkg.gen_portage_config('sys-devel/binutils', watch_in={'pkg': 'sys-devel/binutils'})|indent(8) }}
  {{ pkg.gen_portage_config('sys-devel/binutils-config', watch_in={'pkg': 'sys-devel/binutils'})|indent(8) }}

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
