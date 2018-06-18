glibc:
  pkg.latest:
    - name: sys-libs/glibc
    - require:
      - file: /etc/locale.gen

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
