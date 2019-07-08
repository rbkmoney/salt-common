{% import 'pkg/common' as pkg %}
irqbalance:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('sys-apps/irqbalance') }}
      - {{ pkg.gen_atom('sys-process/numactl') }}
  service.running:
    - name: irqbalance
    - enable: True
