{% import 'pkg/common' as pkg %}
{% if os == 'Gentoo' %}
include:
  - gentoo.portage.packages
{% endif %}

{% if os == 'Ubuntu' %}
pkgrepo_suricata_stable:
  pkgrepo.managed:
    - ppa: oisf/suricata-stable
{% endif %}

net-analyzer/suricata:
  pkg.installed:
    {% if os == 'Gentoo' %}
    - pkgs: 
      - {{ pkg.gen_atom('net-analyzer/suricata') }}
    - require:
      - file: gentoo.portage.packages
    {% elif == 'Ubuntu' %}
    - pkgs:
      - suricata
    - require:
        - pkgrepo: pkgrepo_suricata_stable
    {% endif %}
