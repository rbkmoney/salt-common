include:
  - gentoo.portage
  - vcs.git

{% set sync_uri = salt.pillar.get('repos:gentoo:sync-uri', 'https://anongit.gentoo.org/git/repo/sync/gentoo.git') %}

gentoo:
  file.directory:
    - name: '/usr/portage'
    - create: True
  {% if not ('read-only-repos' in grains and grains['read-only-repos'] == True) %}
  git.latest:
    - name: '{{ sync_uri }}'
    - target: '/usr/portage'
    - rev: master
    - depth: 1
    - force_clone: True
    - force_checkout: True
    - force_reset: True
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
          location: '/usr/portage'
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
