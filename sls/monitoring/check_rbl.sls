{% import 'pkg/common' as pkg %}
{% if grains.os == 'Gentoo' %}
include:
  - gentoo.portage.packages
{% endif %}

net-analyzer/nagios-check_rbl:
  pkg.latest:
    - pkgs:
      {% if grains.os == 'Gentoo' %}
      - {{ pkg.gen_atom('net-analyzer/nagios-check_rbl') }}
      {% elif grains.os_family == 'Debian' %}
      - monitoring-plugins-contrib
      - libmonitoring-plugin-perl
      - libreadonly-perl
      - libdata-validate-domain-perl
      - libdata-validate-ip-perl
      - libnet-dns-perl
      - libnet-dns-sec-perl
      {% endif %}
