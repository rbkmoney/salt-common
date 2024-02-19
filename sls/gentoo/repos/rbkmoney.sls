{% set read_only_repos = ('read-only-repos' in grains and grains['read-only-repos'] == True) %}
{% set repo_name = 'rbkmoney' %}
{% set sync_uri = salt.pillar.get('repos:rbkmoney:sync-uri', 'https://github.com/rbkmoney/gentoo-overlay') %}
include:
  - gentoo.portage

{{ repo_name }}:
  file.directory:
    - name: '/var/db/repos/{{ repo_name }}'
    - create: True
  {% if not read_only_repos %}
  git.latest:
    - name: '{{ sync_uri }}'
    - target: '/var/db/repos/{{ repo_name }}'
    - rev: master
    - force_clone: True
    - force_checkout: True
    - force_reset: True
    - reload_modules: true
    - require:
      - file: {{ repo_name }}
  {% endif %}

/etc/portage/repos.conf/{{ repo_name }}.conf:
  file.managed:
    - create: True
    - replace: False
    - user: root
    - mode: 644
  ini.options_present:
    - require:
      - file: /etc/portage/repos.conf/{{ repo_name }}.conf
    - sections:
        {{ repo_name }}:
          location: '/var/db/repos/{{ repo_name }}'
          auto-sync: {{ 'false' if read_only_repos else 'true' }}
          sync-type: git
          clone-depth: 1
          sync-uri: '{{ sync_uri }}'

/etc/portage/repos.conf/{{ repo_name }}.conf-absent:
  ini.options_absent:
    - name: /etc/portage/repos.conf/{{ repo_name }}.conf
    - sections:
        {{ repo_name }}:
          - sync-depth
