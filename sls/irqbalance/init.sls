irqbalance:
  pkg.installed:
    - pkgs:
      - sys-apps/irqbalance: '[numa]'
      - sys-process/numactl
  service.running:
    - name: irqbalance
    - enable: True
