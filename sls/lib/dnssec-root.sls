net-dns/dnssec-root:
  pkg.latest:
    - pkgs:
      {% if grains.os == 'Gentoo' %}
      - {{ pkg.gen_atom('net-dns/unbound') }}
      {% elif grains.os_family == 'Debian' %}
      - dns-root-data
      {% endif %}
