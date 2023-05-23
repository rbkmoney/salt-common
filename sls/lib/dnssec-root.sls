{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

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
