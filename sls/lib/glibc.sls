{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

sys-libs/glibc:
  pkg.latest:
    - oneshot: True
    - require:
      - file: /etc/locale.gen
      - file: gentoo.portage.packages
    - pkgs:
      - {{ pkg.gen_atom('sys-libs/glibc') }}

/etc/env.d/02locale:
  file.managed:
    - source: salt://core/env.d/02locale
    - mode: 644
    - user: root
    - group: root

/etc/locale.gen:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - contents: |
        en_US.UTF-8 UTF-8
        en_DK.UTF-8 UTF-8

locale-gen:
  cmd.wait:
    - watch:
      - file: /etc/locale.gen
