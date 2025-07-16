include:
  - .cron-freshclam-absent
  - .cron-clamscan-absent

clamd:
  service.dead:
    - enable: False
    {% if grains.os_family == 'Debian' %}
    - name: clamav-daemon
    {% endif %}

freshclam:
  service.dead:
    - enable: False
    {% if grains.os_family == 'Debian' %}
    - name: clamav-freshclam
    {% endif %}

clamav-onacc:
  service.dead:
    - enable: False

app-antivirus/clamav:
  pkg.purged:
    {% if grains.os == 'Gentoo' %}
    - pkgs:
      - 'app-antivirus/clamav'
    {% elif grains.os_family == 'Debian' %}
    - pkgs:
      - clamav
      - clamav-daemon
    {% endif %}
    - require:
      - service: clamd
      - service: freshclam
      - service: clamav-onacc
