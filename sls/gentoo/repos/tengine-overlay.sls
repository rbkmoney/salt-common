# -*- mode: yaml -*-
include:
  - gentoo.portage
  - vcs.git

{% set repo_name = 'tengine-overlay' %}
{% set sync_uri = 'https://github.com/damex/tengine-overlay' }

{{ repo_name }}:
  file.directory:
    - name: '/var/lib/layman/{{ repo_name }}'
    - create: True
  git.latest:
    - name: '{{ sync_uri }}'
    - target: '/var/lib/layman/{{ repo_name }}'
    - rev: master
    - force_clone: True
    - force_checkout: True
  ini_manage.options_present:
    - name: '/etc/portage/repos.conf/{{ repo_name }}.conf'
    - sections:
        {{ repo_name }}:
          location: '/var/lib/layman/{{ repo_name }}'
          sync-type: git
          sync-depth: 1
          sync-uri: '{{ sync_uri }}'
