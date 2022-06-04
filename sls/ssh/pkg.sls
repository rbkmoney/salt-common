{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

net-misc/openssh:
  pkg.latest:
    {% if grains.os == 'Gentoo' %}
    - pkgs:
      - {{ pkg.gen_atom('net-misc/openssh') }}
    - require:
      - file: gentoo.portage.packages
      {{ libc.pkg_dep() }}
    {% elif grains.os_family == 'Debian' %}
    - pkgs:
      - openssh-server
      - openssh-client
      - openssh-sftp-server
    - require:
      {{ libc.pkg_dep() }}
    {% endif %}
