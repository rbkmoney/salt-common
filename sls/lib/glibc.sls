{% set glibc_use = salt['pillar.get']('glibc:use', ['-audit','caps','-docs','gd','multiarch','hardened']) %}
{% set libs_packaged = salt['pillar.get']('libs:packaged', False) %}
sys-libs/glibc:
  pkg.latest:
    - version: "[{{ ','.join(glibc_use) }}]"
    {% if libs_packaged %}
    - binhost: force
    {% endif %}
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
