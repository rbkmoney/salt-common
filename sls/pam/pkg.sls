# TODO: remove from deps
{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

sys-libs/pam:
  pkg.installed:
    - oneshot: True
    - pkgs:
      - {{ pkg.gen_atom('sys-libs/pam') }}
    - require:
      - file: gentoo.portage.packages

sys-auth/pambase:
  pkg.latest:
    - oneshot: True
    - pkgs:
      - {{ pkg.gen_atom('sys-auth/pambase') }}
    - require:
      - file: gentoo.portage.packages

virtual/pam:
  pkg.latest:
    - require:
      - pkg: sys-libs/pam
