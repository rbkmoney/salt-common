{% import 'pkg/common' as pkg %}
include:
  - .packages
  - gentoo.repos.gentoo
{% if pillar.get('overlay', False) %}
  - gentoo.repos.{{ pillar.get('overlay') }}
{% endif %}  

sys-apps/portage:
  pkg.latest:
    - reload_modules: True
    - refresh: True
    - pkgs:
      - {{ pkg.gen_atom('sys-apps/portage') }}
    - require:
      - file: gentoo.portage.packages
    {% if not ('read-only-repos' in grains and grains['read-only-repos'] == True) %}
    # need all repos here since 'refresh' of pkg module is executed once per run
      - file: /etc/portage/repos.conf/gentoo.conf
    {% if pillar.get('overlay', False) %}
      - file: /etc/portage/repos.conf/{{ pillar.get('overlay') }}.conf
    {% endif %}
    {% endif %}

app-portage-purged:
  pkg.purged:
    - pkgs:
      - app-portage/epkg
