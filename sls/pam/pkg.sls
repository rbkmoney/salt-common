# TODO: remove from deps
{% import 'pkg/common' as pkg %}
{% if grains.os == 'Gentoo' %}
include:
  - gentoo.portage.packages
{% endif %}

sys-libs/pam:
{% if grains.os == 'Gentoo' %}
  pkg.installed:
    - oneshot: True
    - pkgs:
      - {{ pkg.gen_atom('sys-libs/pam') }}
    - require:
      - file: gentoo.portage.packages
{% elif grains.os_family == 'Debian' %}
  pkg.latest:
    - pkgs:
      - libpam-modules
{% endif %}
{% if grains.os == 'Gentoo' %}
sys-auth/pambase:
  pkg.latest:
    - oneshot: True
    - pkgs:
      - {{ pkg.gen_atom('sys-auth/pambase') }}
    - require:
      - file: gentoo.portage.packages
{% endif %}
