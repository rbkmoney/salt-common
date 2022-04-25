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

/var/lib/filebeat/module/:
  file.recurse:
    - source: salt://filebeat/files/module/
    - file_mode: 640
    - dir_mode: 750
    - user: root
    - group: root
