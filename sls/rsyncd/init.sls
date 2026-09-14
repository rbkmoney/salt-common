{% import 'pkg/common' as pkg %}
{% import 'lib/libc.sls' as libc %}
include:
  - lib.libc

net-misc/rsync:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('net-misc/rsync') }}
    - require:
      {{ libc.pkg_dep() }}

/etc/rsyncd.conf:
  file.managed:
    - source: salt://rsyncd/files/rsyncd.conf
    - mode: 644
    - user: root
    - group: root

/etc/rsyncd.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

# Generated rsyncd configuration from pillar:
#   rsyncd:
#     modules:
#       <module-name>:
#         path: /var/cache/binpkgs
#         comment: ...
#         hosts_allow: host.name
# rendered into /etc/rsyncd.d/salt.conf (the main rsyncd.conf
# template pulls it in via '&include /etc/rsyncd.d')
{% set modules = salt.pillar.get('rsyncd:modules', {}) %}
/etc/rsyncd.d/salt.conf:
  file.managed:
    - contents: |
        {% for name, opts in modules.items() %}
        [{{ name }}]
        {% for key, value in opts.items() %}
        {{ key | replace('_', ' ') }} = {{ value }}
        {% endfor %}
        {% endfor %}
    - require:
      - file: /etc/rsyncd.d/
    - watch_in:
      - service: rsyncd

rsyncd:
  service.running:
    - enable: True
    - watch:
      - pkg: net-misc/rsync
      - file: /etc/rsyncd.conf
      - file: /etc/rsyncd.d/
