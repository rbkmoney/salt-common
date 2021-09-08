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
  service.runing:
  - enable: True
  - require:
    - pkg: sys-process/systemd-cron
{% endif %}
