{% import 'pkg/common' as pkg %}
include:
  {% if grains.os == 'Gentoo' %}
  - gentoo.portage.packages
  {% elif grains.os == 'Ubuntu' %}
  - .hashicorp-repo-ubuntu
  {% endif %}

app-admin/vault:
  pkg.latest:
  {% if grains.os == 'Gentoo' %}
    - pkgs:
      - {{ pkg.gen_atom('app-admin/vault') }}
    - require:
      - file: gentoo.portage.packages
  {% elif grains.os == 'Ubuntu' %}
    - name: vault
    - require:
      - file: /etc/apt/sources.list.d/hashicorp.list
  {% endif %}
