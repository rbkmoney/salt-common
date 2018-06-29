{% set git_use = salt['pillar.get']('git:use', ['-gpg','-pcre-jit']) %}
git:
  pkg.latest:
    - refresh: false
    - name: dev-vcs/git
    - version: "[{{ ','.join(git_use) }}]"
