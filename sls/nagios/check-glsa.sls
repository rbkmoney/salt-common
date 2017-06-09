include:
  - cron

net-analyzer/nagios-check_glsa2:
  pkg.latest

glsa-check-generate:
  cron.present:
    - identifier: glsa-check-generate
    - name: /usr/lib64/nagios/plugins/check_glsa2_cached.sh --generate
    - minute: '8'
    - user: root
    - require:
      - pkg: net-analyzer/nagios-check_glsa2
