{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

lksctp-tools:
  pkg.latest:
    - oneshot: True
    - pkgs:
      - {{ pkg.gen_atom('net-misc/lksctp-tools') }}
    - require:
      - file: gentoo.portage.packages
  {% if grains['osarch'].startswith('arm') %}
  portage_config.flags:
    - name: net-misc/lksctp-tools
    - accept_keywords:
      - ~arm
    - watch_in:
      - pkg: lksctp-tools
  {% endif %}
