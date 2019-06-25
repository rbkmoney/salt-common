{% import 'pkg/common' as pkg %}
sys-devel/binutils:
  pkg.installed:
   - pkgs:
      - {{ pkg.gen_atom('sys-devel/binutils') }}

'emerge -q --prune sys-devel/binutils':
  cmd.run:
    - onchanges:
      - pkg: sys-devel/binutils
