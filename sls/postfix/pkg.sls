{% import 'pkg/common' as pkg %}
mail-mta/postfix:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('mail-mta/postfix') }}
  {{ pkg.gen_portage_config('mail-mta/postfix', watch_in={'pkg': 'mail-mta/postfix'})|indent(8) }}
