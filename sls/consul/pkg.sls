{% import 'pkg/common' as pkg %}
include:
  {% if grains.os == 'Gentoo' %}
  - gentoo.portage.packages
  {% elif grains.os == 'Ubuntu' %}
  - .hashicorp-repo-ubuntu
  {% endif %}

app-admin/consul:
  pkg.latest:
  {% if grains.os == 'Gentoo' %}
    - pkgs:
      - {{ pkg.gen_atom('app-admin/consul') }}
    - require:
      - file: gentoo.portage.packages
  {% elif grains.os == 'Ubuntu' %}
    - name: consul
    - require:
      - file: /etc/apt/sources.list.d/hashicorp.list
  {% endif %}
