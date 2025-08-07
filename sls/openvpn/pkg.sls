{% if grains.os == 'Gentoo' %}
{% import 'pkg/common' as pkg %}
{{ pkg.gpp_include() }}
{{ pkg.pkg_latest('net-vpn/openvpn') }}
{% elif grains.os_family == 'Debian' %}
net-vpn/openvpn:
{% set pkg_prefix = 'apt:packages:openvpn:' %}
{% set openvpn_version = salt.pillar.get(pkg_prefix + 'version', '') %}
{% set hold_default = True if openvpn_version else False %}
{% if openvpn_version %}
  pkg.installed:
{% else %}
  pkg.latest:
{% endif %}
    - pkgs:
      - openvpn: {{ openvpn_version }}
    - hold: {{ salt.pillar.get(pkg_prefix + 'hold', hold_default) }}
    - update_holds: {{ salt.pillar.get(pkg_prefix + 'update_holds', hold_default) }}
{% endif %}
