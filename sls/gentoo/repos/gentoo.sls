# -*- mode: yaml -*-
include:
  - gentoo.portage
  - vcs.git

{% set sync_uri = 'git://git.bakka.su/gentoo-mirror' %}

gentoo:
  file.directory:
    - name: '/usr/portage'
    - create: True
  git.latest:
    - name: '{{ sync_uri }}'
    - target: '/usr/portage'
    - rev: master
    - force_clone: True
    - force_checkout: True
  ini_manage.options_present:
    - name: '/etc/portage/repos.conf/gentoo.conf'
    - sections:
        DEFAULT:
          main-repo: gentoo
        gentoo:
          location: '/usr/portage'
          sync-type: git
          sync-depth: 1
          sync-uri: '{{ sync_uri }}'
