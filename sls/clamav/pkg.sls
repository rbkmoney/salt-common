{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
{% if grains.os == 'Gentoo' %}
include:
  - gentoo.portage.packages
{% endif %}

app-antivirus/clamav:
  pkg.installed:
    {% if grains.os == 'Gentoo' %}
    - pkgs:
      - {{ pkg.gen_atom('app-antivirus/clamav') }}
    - require:
      - file: gentoo.portage.packages
    {% elif grains.os_family == 'Debian' %}
    - pkgs:
      - clamav
      - clamav-daemon
    {% endif %}

/usr/local/bin/clam-wrapper.py:
  file.managed:
    - source: salt://clamav/files/clam-wrapper.py
    - mode: 755
    - user: root
    - group: root
