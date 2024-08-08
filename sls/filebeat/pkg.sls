{% import 'pkg/common' as pkg %}
include:
{% if grains['os'] == 'Gentoo' %}
  - gentoo.portage.packages
{% elif grains['os'] == 'Ubuntu' %}
  - elasticsearch.repo-apt
{% elif grains['os'] == 'Debian' %}
  - elasticsearch.repo-apt
{% endif %}

app-admin/filebeat:
  pkg.installed:
{% if grains['os'] == 'Gentoo' %}
    - pkgs:
      - {{ pkg.gen_atom('app-admin/filebeat') }}
    - require:
      - file: gentoo.portage.packages
{% elif grains['os'] == 'Ubuntu' %}
    - name: filebeat
    - require:
      - file: elastic-oss-repo
{% elif grains['os'] == 'Debian' %}
    - name: filebeat
    - require:
      - file: elastic-oss-repo
{% endif %}

