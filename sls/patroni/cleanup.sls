drop_default_db:
  postgres_cluster.absent:
    - name: 'main'
    - version: {{ salt['pillar.get']('patroni:pgdg_release', '16') }}
