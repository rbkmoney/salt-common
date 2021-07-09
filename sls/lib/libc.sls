{% import 'pkg/common' as pkg with context %}
include:
  - gentoo.portage.packages

{% macro pkg_dep() -%}
{%- if grains['elibc'] == 'glibc' -%}
- pkg: sys-libs/glibc
{% endif %}
{%- endmacro -%}

{% if grains['elibc'] == 'glibc' %}
sys-libs/glibc:
  pkg.latest:
    - oneshot: True
    - require:
      - file: gentoo.portage.packages
      - file: /etc/locale.gen
    - pkgs:
      - {{ pkg.gen_atom('sys-libs/glibc') }}

/etc/locale.gen:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - contents: |
        en_US.UTF-8 UTF-8
        en_IE.UTF-8 UTF-8
        en_DK.UTF-8 UTF-8
        ru_RU.UTF-8 UTF-8

locale-gen:
  cmd.wait:
    - watch:
      - file: /etc/locale.gen

eselect-locale:
  eselect.set:
    - name: locale
    - target: {{ salt.pillar.get('locale:LANG', 'en_IE.utf8') }}
    - require:
      - cmd: locale-gen

/etc/env.d/02locale:
  augeas.change:
    - require:
      - cmd: locale-gen
    - context: /files/etc/env.d/02locale
    - lens: Shellvars.lns
    - changes:
      - set LC_TIME "{{ salt.pillar.get('locale:LC_TIME','en_IE.UTF-8') }}"
      - set LC_ALL "{{ salt.pillar.get('locale:LC_ALL','en_IE.UTF-8') }}"
{% endif %}
