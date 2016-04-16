irqbalance:
  pkg.purged:
    - pkgs:
      - sys-apps/irqbalance: '[numa]'
      - sys-process/numactl
    - require:
      - service: irqbalance
  service.disabled:
    - name: irqbalance
