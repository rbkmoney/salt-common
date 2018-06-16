include:
  - gentoo.portage
  - vcs.git

{% set repo_name = 'go-overlay' %}
{% set sync_uri = 'https://github.com/Dr-Terrible/go-overlay.git' %}

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
          location: '/var/lib/layman/{{ repo_name }}'
          auto-sync: {{ 'false' if ('read-only-repos' in grains and grains['read-only-repos'] == True) else 'true' }}
          sync-type: git
          clone-depth: 1
          sync-uri: '{{ sync_uri }}'

/etc/portage/repos.conf/{{ repo_name }}.conf-absent:
  ini.options_absent:
    - name: /etc/portage/repos.conf/{{ repo_name }}.conf
    - sections:
        {{ repo_name }}:
          - sync-depth
