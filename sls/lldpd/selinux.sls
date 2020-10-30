{% if salt['grains.get']('selinux:enabled', False) == True %}
{%- from tpldir+"/map.jinja" import confmap with context -%}
selinux-lldpd-pkg:
  pkg.latest:
    - name: {{ confmap.pkgSelinuxPolicy }}
    - require_in:
      - pkg: net-misc/lldpd

selinux-relabel-pkg-lldpd:
  cmd.run:
    - names:
      - restorecon -Frv /etc/lldpd*
 {% if grains['os_family'] == 'Gentoo' %}
      - rlpkg {{ confmap.pkg }}
 {% endif %}
    - onchanges:
      - pkg: selinux-lldpd-pkg
    - require:
      - pkg: selinux-lldpd-pkg
    - require_in:
      - service: lldpd
    - watch_in:
      - service: lldpd
{% endif %}
