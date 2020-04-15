{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
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
      - git: gentoo
    {% if pillar.get('overlay', False) %}
      - git: {{ pillar.get('overlay') }}
    {% endif %}
    {% endif %}

app-portage-purged:
  pkg.purged:
    - pkgs:
      - app-portage/epkg

/etc/portage/repos.conf/:
  file.directory:
    - mode: 755
    - user: root
    - group: root

/etc/portage/profile/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/etc/portage/env/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

