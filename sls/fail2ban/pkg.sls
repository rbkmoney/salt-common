{% import 'pkg/common' as pkg with context %}
{% if grains.os == 'Gentoo' %}
include:
  - gentoo.portage.packages
{% endif %}

net-analyzer/fail2ban:
  pkg.latest:
    {% if grains.os == 'Gentoo' %}
    - pkgs:
      - {{ pkg.gen_atom('net-analyzer/fail2ban') }}
    - require:
      - file: gentoo.portage.packages
    {% elif grains.os_family == 'Debian' %}
    - pkgs:
       - fail2ban
       - python3-pyinotify
    {% endif %}
