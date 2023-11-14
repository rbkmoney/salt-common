{% import 'pkg/common' as pkg %}
{% if grains.os == 'Gentoo' %}
include:
  - gentoo.portage.packages
{% elif grains.os == 'Ubuntu' %}
include:
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
    - pkgs:
        - consul
    - require:
      - file: /etc/apt/sources.list.d/hashicorp.list
  {% endif %}
