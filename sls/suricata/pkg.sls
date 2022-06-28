{% import 'pkg/common' as pkg %}
{% if grains.os == 'Gentoo' %}
include:
  - gentoo.portage.packages
{% endif %}

{% if grains.os == 'Ubuntu' %}
pkgrepo_suricata_stable:
  pkgrepo.managed:
    - ppa: oisf/suricata-stable
{% endif %}

net-analyzer/suricata:
  pkg.installed:
    {% if grains.os == 'Gentoo' %}
    - pkgs: 
      - {{ pkg.gen_atom('net-analyzer/suricata') }}
    - require:
      - file: gentoo.portage.packages
    {% elif grains.os == 'Ubuntu' %}
    - pkgs:
      - suricata
    - refresh: true
    - require:
        - pkgrepo: pkgrepo_suricata_stable
    {% endif %}
