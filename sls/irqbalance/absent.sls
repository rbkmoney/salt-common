irqbalance:
  pkg.purged:
    - pkgs:
      - sys-apps/irqbalance
      - sys-process/numactl
  service.dead:
    - name: irqbalance
    - enable: False
    - onfail:
      - pkg: irqbalance
    - onchanges:
      - pkg: irqbalance      