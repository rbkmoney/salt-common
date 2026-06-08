include:
  - .pkg
  - .cleanup
  - .config
  - .pgbouncer

postgresql:
  service.disabled:
    - require:
      - pkg: dev-db/postgresql

extend:
  /etc/pgbouncer/userlist.generated:
    file.managed:
      - require:
        - service: patroni
