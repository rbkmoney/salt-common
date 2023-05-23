{% import 'pkg/common' as pkg %}
{% if grains.os == 'Gentoo' %}
include:
  - gentoo.portage.packages
{% endif %}

net-dns/dnssec-root:
  pkg.latest:
    {% if grains.os == 'Gentoo' %}
    - pkgs:
        - {{ pkg.gen_atom('net-dns/dnssec-root') }}
    - require:
      - file: gentoo.portage.packages
    {% elif grains.os_family == 'Debian' %}
    - pkgs:
        - dns-root-data
    {% endif %}
