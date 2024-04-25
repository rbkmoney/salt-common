{% import 'pkg/common' as pkg with context %}
{% if grains.os == 'Gentoo' %}
include:
  - gentoo.portage.packages
{% endif %}

{% macro pkg_dep() -%}
{%- if grains['elibc'] == 'glibc' -%}
- pkg: sys-libs/glibc
{%- elif grains['elibc'] == 'musl' %}
- pkg: sys-libs/musl
{% endif %}
{%- endmacro -%}

{% if grains['elibc'] == 'glibc' %}
sys-libs/glibc:
  pkg.latest:
    {% if grains.os == 'Gentoo' %}
    - oneshot: True
    - pkgs:
      - {{ pkg.gen_atom('sys-libs/glibc') }}
    {% elif grains.os_family == 'Debian' %}
    - pkgs:
      - libc6
      - libc-bin
    {% endif %}
    - require:
      {% if grains.os == 'Gentoo' %}
      - file: gentoo.portage.packages
      {% endif %}
      - file: /etc/locale.gen

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

{% if grains.os == 'Gentoo' %}
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
{% elif grains['elibc'] == 'musl' %}
sys-libs/musl:
  pkg.latest:
    {% if grains.os == 'Gentoo' %}
    - oneshot: True
    - pkgs:
      - {{ pkg.gen_atom('sys-libs/musl') }}
    - require:
      - file: gentoo.portage.packages
    {% elif grains.os_family == 'Debian' %}
    - pkgs:
      - musl
    {% endif %}
{% endif %}
