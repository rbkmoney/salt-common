{% if grains['init'] != 'systemd' %}
include:
  - cron.cronie
{% else %}
{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages

sys-process/systemd-cron:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('sys-process/systemd-cron') }}
    - require:
      - file: gentoo.portage.packages

cron.target:
  service.running:
  - enable: True
  - require:
    - pkg: sys-process/systemd-cron

 {% if salt['file.access']('/usr/bin/crontab', 'x') == False %}
/usr/bin/crontab:
   file.symlink:
   - target: /usr/bin/crontab-systemd
   - require:
     - pkg: sys-process/systemd-cron
 {% endif %}

{% endif %}
