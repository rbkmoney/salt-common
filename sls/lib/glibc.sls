# TODO: change pkg -> cmd.run emerge -1 ...
{% import 'pkg/common' as pkg %}
sys-libs/glibc:
  pkg.latest:
    - require:
      - file: /etc/locale.gen
    - pkgs:
      - {{ pkg.gen_atom('sys-libs/glibc') }}
  {{ pkg.gen_portage_config('sys-libs/glibc', watch_in={'pkg': 'sys-libs/glibc'})|indent(8) }}

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
