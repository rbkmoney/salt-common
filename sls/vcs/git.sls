{% set git_use = salt['pillar.get']('git:use', ['-gpg','-pcre-jit']) %}
git:
  portage_config.flags:
    - use: {{ git_use }}
  pkg.latest:
    - refresh: false
    - name: dev-vcs/git
    - version: "[{{ ','.join(git_use) }}]"
    - require:
      - portage_config: git
