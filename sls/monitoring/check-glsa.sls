include:
  - cron

{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

net-analyzer/nagios-check_glsa2:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('net-analyzer/nagios-check_glsa2') }}
    - require:
      - file: gentoo.portage.packages

glsa-check-generate:
  file.managed:
  - source: salt://{{ slspath }}/files/glsa.cron
  - name: /etc/cron.d/glsa-check-generate
  - require:
	- pkg: net-analyzer/nagios-check_glsa2

glsa-check-generate-old-absent:
  cron.absent:
    - identifier: glsa-check-generate
    - name: /usr/lib64/nagios/plugins/check_glsa2_cached.sh --generate
    - user: root
    - require:
      - file: glsa-check-generate
