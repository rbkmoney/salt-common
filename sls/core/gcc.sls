{% import 'pkg/common' as pkg %}
sys-devel/gcc:
  pkg.installed:
   - pkgs:
      - {{ pkg.gen_atom('sys-devel/gcc') }}

'emerge -q --prune sys-devel/gcc':
  cmd.run:
    - onchanges:
      - pkg: sys-devel/gcc
