{% import 'pkg/common' as pkg %}
include:
{% if grains['os'] == 'Gentoo' %}
  - gentoo.portage.packages
{% elif grains['os'] == 'Ubuntu' %}
  - elasticsearch.repo-apt
{% elif grains['os'] == 'Debian' %}
  - elasticsearch.repo-apt
{% endif %}

sys-process/auditbeat:
  pkg.installed:
{% if grains['os'] == 'Gentoo' %}
    - pkgs:
      - {{ pkg.gen_atom('sys-process/auditbeat') }}
    - require:
      - file: gentoo.portage.packages
{% elif grains['os'] == 'Ubuntu' %}
    - name: auditbeat
    - require:
      - file: /etc/apt/sources.list.d/elastic.list
{% elif grains['os'] == 'Debian' %}
    - name: auditbeat
    - require:
      - file: /etc/apt/sources.list.d/elastic.list
{% endif %}
