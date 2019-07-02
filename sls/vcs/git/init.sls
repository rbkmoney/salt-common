{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

# must be pkg.installed and not pkg.latest to avoid chicken and egg problem
# in 'gentoo' state; also git must be present in VM image
dev-vcs/git:
  pkg.installed:
    - refresh: false
    - reload_modules: true
    - pkgs:
      - {{ pkg.gen_atom('dev-vcs/git') }}
    - require:
      - file: gentoo.portage.packages
