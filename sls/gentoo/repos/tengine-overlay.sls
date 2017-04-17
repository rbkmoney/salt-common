# -*- mode: yaml -*-
include:
  - gentoo.portage
  - vcs.git

{% set repo_name = 'tengine-overlay' %}
{% set sync_uri = 'https://github.com/damex/tengine-overlay' %}

{{ repo_name }}:
  file.directory:
    - name: '/var/lib/layman/{{ repo_name }}'
    - create: True
  {% if not ('read-only-repos' in grains and grains['read-only-repos'] == True) %}
  git.latest:
    - name: '{{ sync_uri }}'
    - target: '/var/lib/layman/{{ repo_name }}'
    - rev: master
    - force_clone: True
    - force_checkout: True
  {% endif %}

/etc/portage/repos.conf/{{ repo_name }}.conf:
  ini.options_present:
    - sections:
        {{ repo_name }}:
          location: '/var/lib/layman/{{ repo_name }}'
          auto-sync: {{ 'false' if ('read-only-repos' in grains and grains['read-only-repos'] == True) else 'true' }}
          sync-type: git
          clone-depth: 1
          sync-uri: '{{ sync_uri }}'
  ini.options_absent:
    - sections:
        {{ repo_name }}:
          - sync-depth
