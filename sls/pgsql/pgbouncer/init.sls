{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

dev-db/pgbouncer:
  pkg.latest:
    - pkgs:
      {% if grains.os == 'Gentoo' %}
      - {{ pkg.gen_atom('dev-db/pgbouncer') }}
      {% elif grains.os_family == 'Debian' %}
      - pgbouncer
      {% endif %}
    - require:
      {{ libc.pkg_dep() }}

/etc/security/limits.d/pgbouncer:
  file.absent
/etc/pgbouncer.ini:
  file.absent

{% if grains['init'] == 'openrc' %}
/etc/conf.d/pgbouncer:
  file.managed:
    - contents: |
        # Managed by Salt
        PIDFILE="/run/pgbouncer.pid"
        INIFILE="/etc/pgbouncer/pgbouncer.ini"
        NICE_TIMEOUT=30
        FORCE_QUIT="no"
        FORCE_QUIT_TIMEOUT=2
        rc_ulimit="-n 65535"
{% elif grains['init'] == 'systemd' %}
/etc/conf.d/pgbouncer: file.absent
{% endif %}

/etc/pgbouncer/:
  file.directory:
    - create: True
    - user: postgres
    - group: postgres
    - mode: 755
    - require:
      - pkg: dev-db/pgbouncer

/etc/pgbouncer/pgbouncer.ini:
  file.managed:
    - source: salt://{{ slspath }}/files/pgbouncer.ini.tpl
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 640
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
    - source: salt://{{ slspath }}/files/userlist.sql
    - user: postgres
    - group: postgres
    - mode: 640
    - require:
      - file: /etc/pgbouncer/

/etc/pgbouncer/userlist.generated:
  file.managed:
    - replace: False
    - user: postgres
    - group: postgres
    - mode: 640
  cmd.run:
    - name: >-
        sudo -u postgres psql -h /var/lib/postgresql/patroni -AF' ' -t
        -f /etc/pgbouncer/userlist.sql -o /etc/pgbouncer/userlist.generated
    - require:
      - file: /etc/pgbouncer/userlist.sql
      - file: /etc/pgbouncer/userlist.generated

/etc/pgbouncer/userlist.txt:
  file.managed:
    - source: /etc/pgbouncer/userlist.generated
    - user: postgres
    - group: postgres
    - mode: 640
    - require:
      - cmd: /etc/pgbouncer/userlist.generated

pgbouncer:
  service.running:
    - enable: True
    - watch:
      {{ libc.pkg_dep() }}
      - pkg: dev-db/pgbouncer
      - file: /etc/security/limits.d/pgbouncer
      - file: /etc/conf.d/pgbouncer
      - file: /etc/pgbouncer/
      - file: /etc/pgbouncer/pgbouncer.ini
      - file: /etc/pgbouncer/pg_hba.conf
      - file: /etc/pgbouncer/userlist.txt
