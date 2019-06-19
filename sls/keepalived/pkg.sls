{% import 'pkg/common' as pkg %}
pkg_keepalived:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('sys-cluster/keepalived') }}
  {{ pkg.gen_portage_config('sys-cluster/keepalived', watch_in={'pkg': 'pkg_keepalived'})|indent(8) }}
