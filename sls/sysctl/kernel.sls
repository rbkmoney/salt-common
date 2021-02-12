kernel.pid_max:
  sysctl.present:
    - value: 999999

kernel.panic:
  sysctl.present:
    - value : 30

kernel.sched_migration_cost_ns:
  sysctl.present:
    - value: 5000000
    - onlyif:
      - test -f /proc/sys/kernel/sched_migration_cost_ns
