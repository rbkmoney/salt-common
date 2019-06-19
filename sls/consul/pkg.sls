{% import 'pkg/common' as pkg %}
app-admin/consuela:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('app-admin/consul') }}
  {{ pkg.gen_portage_config('app-admin/consul', watch_in={'pkg': 'app-admin/consuela'})|indent(8) }}
