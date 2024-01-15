{% set tzpath = salt.pillar.get('timezone:path', 'Etc/UTC') %}
include:
  - lib.timezone-data

/etc/timezone:
  file.managed:
    - contents: "{{ tzpath }}"
    - mode: 644
    - user: root
    - group: root
    - require_in:
      - pkg: sys-libs/timezone-data

/etc/localtime:
  file.symlink:
    - target: "/usr/share/zoneinfo/{{ tzpath }}"
    - force: True
    - require_in:
      - pkg: sys-libs/timezone-data
