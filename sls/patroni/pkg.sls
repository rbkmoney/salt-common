{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc
  {% if grains.os == 'Gentoo' %}
  - python
  - gentoo.portage.packages
  - gentoo.makeconf
  {% elif grains.os_family == 'Debian' %}
  - .repo-apt
  {% endif %}

dev-db/postgresql:
  {% if grains.os_family == 'Gentoo' %}
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-db/postgresql') }}
    - require:
      {{ libc.pkg_dep() }}
  {% elif grains.os_family == 'Debian' %}
  pkg.latest:
    - pkgs:
      - postgresql-{{ salt.pillar.get('patroni:pgdg_release', '16') }}
      - postgresql-contrib
    - refresh: True
    - require:
      - file: /etc/apt/sources.list.d/patroni.sources
      {{ libc.pkg_dep() }}
  {% endif %}

dev-db/patroni:
  {% if grains.os_family == 'Gentoo' %}
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-db/patroni') }}
  {% elif grains.os_family == 'Debian' %}
  pkg.latest:
    - pkgs:
      - libpq-dev
      - python3-psycopg2
      - python3-consul
      - python3-systemd
      - patroni
    - refresh: True
    - require:
      - file: /etc/apt/sources.list.d/patroni.sources
  {% endif %}
  
{% if grains.os == 'Ubuntu' %}
initial_symlink:
  file.symlink:
    - name: /usr/sbin/pg_controldata
    - target: /usr/lib/postgresql/{{ salt.pillar.get('patroni:pgdg_release', '16') }}/bin/pg_controldata
    - require:
      - pkg: dev-db/postgresql

{% set dir_contents = salt['file.find'](path="/usr/lib/postgresql/"~salt.pillar.get('patroni:pgdg_release', '16')~"/bin", type="ff", print="name") %}
{% for item in dir_contents %}
/usr/sbin/{{ item }}:
  file.symlink:
    - target: /usr/lib/postgresql/{{ salt.pillar.get('patroni:pgdg_release', '16') }}/bin/{{ item }}
    - require:
      - pkg: dev-db/postgresql
{% endfor %}
{% endif %}
