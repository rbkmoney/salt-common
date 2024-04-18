{% if grains['init'] != 'systemd' %}
include:
  - cron.cronie
{% else %}
{% import 'pkg/common' as pkg %}
{% if grains.os == 'Gentoo' %}
include:
  - gentoo.portage.packages
{% endif %}

sys-process/systemd-cron:
  pkg.installed:
    {% if grains.os == 'Gentoo' %}
    - pkgs:
      - {{ pkg.gen_atom('sys-process/systemd-cron') }}
    - require:
      - file: gentoo.portage.packages
    {% elif grains.os_family == 'Debian' %}
    - pkgs:
      - systemd-cron
    {% endif %}

cron.target:
  service.running:
  - enable: True
  - require:
    - pkg: sys-process/systemd-cron

CRON_TZ:
  cron.env_present:
    - value: "\"{{ salt.pillar.get('timezone:path', 'Etc/UTC') }}\""
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
