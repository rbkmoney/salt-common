include:
  - gentoo.portage
  - vcs.git

{% set sync_uri = salt.pillar.get('repos:gentoo:sync-uri', 'https://anongit.gentoo.org/git/repo/sync/gentoo.git') %}

gentoo:
  file.directory:
    - name: '/var/db/repos/gentoo'
    - create: True
  {% if not ('read-only-repos' in grains and grains['read-only-repos'] == True) %}
  git.latest:
    - name: '{{ sync_uri }}'
    - target: '/var/db/repos/gentoo'
    - rev: master
    - depth: 1
    - force_clone: True
    - force_checkout: True
    - reload_modules: true
    - require_in:
      - pkg: sys-apps/portage
  {% endif %}

/etc/portage/repos.conf/gentoo.conf:
  file.managed:
    - create: True
    - replace: False
    - user: root
    - mode: 644
  ini.options_present:
    - require:
      - file: /etc/portage/repos.conf/gentoo.conf
    - sections:
        DEFAULT:
          main-repo: gentoo
        gentoo:
          location: '/var/db/repos/gentoo'
          auto-sync: {{ 'false' if ('read-only-repos' in grains and grains['read-only-repos'] == True) else 'true' }}
          sync-type: git
          clone-depth: 1
          sync-uri: '{{ sync_uri }}'

/etc/portage/repos.conf/gentoo.conf-absent:
  ini.options_absent:
    - name: /etc/portage/repos.conf/gentoo.conf
    - sections:
        gentoo:
          - sync-depth
