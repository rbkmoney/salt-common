# -*- mode: yaml -*-
include:
  - gentoo.portage
  - vcs.git

{% set repo_name = 'baka-bakka' %}
{% set sync_uri = 'git://git.bakka.su/baka-bakka' %}

{{ repo_name }}:
  file.directory:
    - name: '/var/lib/layman/{{ repo_name }}'
    - create: True
  {% if ('read-only-repos' in grains and grains['read-only-repos'] == True) %}
  git.latest:
    - name: '{{ sync_uri }}'
    - target: '/var/lib/layman/{{ repo_name }}'
    - rev: master
    - force_clone: True
    - force_checkout: True
  {% endif %}
  ini.options_present:
    - name: '/etc/portage/repos.conf/{{ repo_name }}.conf'
    - sections:
        {{ repo_name }}:
          location: '/var/lib/layman/{{ repo_name }}'
          auto-sync: {{ 'false' if ('read-only-repos' in grains and grains['read-only-repos'] == True) else 'true' }}
          sync-type: git
          sync-depth: 1
          sync-uri: '{{ sync_uri }}'



