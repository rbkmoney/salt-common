{% import 'pkg/common' as pkg %}
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
