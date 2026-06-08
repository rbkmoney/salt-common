include:
  - lib.libc

dev-db/pgbouncer:
  pkg.latest:
    {% if grains.os_family == 'Gentoo' %}
    - pkgs:
      - {{ pkg.gen_atom('dev-db/pgbouncer') }}
    {% elif grains.os_family == 'Debian' %}
    - pkgs:
      - pgbouncer
    {% endif %}
    - require:
      {{ libc.pkg_dep() }}

/etc/pgbouncer/:
  file.directory:
    - create: True
    - user: postgres
    - group: postgres
    - mode: 775
    - require:
      - pkg: dev-db/pgbouncer

/etc/pgbouncer/pgbouncer.ini:
  file.managed:
    - source: salt://pgsql/pgbouncer/files/pgbouncer.ini.tpl
    - user: postgres
    - group: postgres
    - mode: 640
    - template: jinja
    - require:
      - file: /etc/pgbouncer/

/etc/pgbouncer/pg_hba.conf:
  file.managed:
    - source: salt://pgsql/files/pg_hba.conf.tpl
    - template: jinja
    - defaults:
        pillar_prefix: pgbouncer
    - user: postgres
    - group: postgres
    - require:
      - file: /etc/pgbouncer/

/etc/pgbouncer/userlist.sql:
  file.managed:
    - source: salt://pgsql/pgbouncer/files/userlist.sql
    - mode: 644
    - user: postgres
    - group: postgres
    - require:
      - file: /etc/pgbouncer/

/etc/pgbouncer/userlist.generated:
  file.managed:
    - replace: False
    - user: postgres
    - group: postgres
    - mode: 640
  cmd.run:
    - name: |
        sudo -u postgres psql -h /var/lib/postgresql/patroni -AF' ' -t -f /etc/pgbouncer/userlist.sql -o /etc/pgbouncer/userlist.generated
    - require:
      - file: /etc/pgbouncer/userlist.sql
      - file: /etc/pgbouncer/userlist.generated

/etc/pgbouncer/userlist.txt:
  file.managed:
    - source: /etc/pgbouncer/userlist.generated
    - user: postgres
    - group: postgres
    - require:
      - cmd: /etc/pgbouncer/userlist.generated

pgbouncer:
  service.running:
    - enable: True
    - watch:
      - pkg: dev-db/pgbouncer
      - file: /etc/pgbouncer/
    - require:
      - file: /etc/pgbouncer/pgbouncer.ini
      - file: /etc/pgbouncer/pg_hba.conf
      - file: /etc/pgbouncer/userlist.txt

pgbouncer-reload:
  service.running:
    - name: pgbouncer
    - reload: True
    - require:
      - pkg: dev-db/pgbouncer
      - file: /etc/pgbouncer/
    - watch:
      - file: /etc/pgbouncer/pgbouncer.ini
      - file: /etc/pgbouncer/pg_hba.conf
      - file: /etc/pgbouncer/userlist.txt
