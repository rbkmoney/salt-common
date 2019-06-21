irqbalance:
  pkg.purged:
    - pkgs:
      - sys-apps/irqbalance
      - sys-process/numactl
    - require:
      - service: irqbalance
  service.dead:
    - name: irqbalance
    - enable: False
    - onfail:
      - pkg: irqbalance
