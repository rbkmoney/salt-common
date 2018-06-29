{% set git_use = salt['pillar.get']('git:use', ['-gpg','-pcre-jit']) %}
dev-vcs/git:
  portage_config.flags:
    - use: {{ git_use }}
  pkg.latest:
    - refresh: false
    - version: "[{{ ','.join(git_use) }}]"
    - require:
      - portage_config: dev-vcs/git
    - reload_modules: true
