{% set py3_slot = pillar.get("python3:slot", '3.11') %}
{% set py3_slot_nodot = py3_slot.replace('.', '') %}
{% import 'pkg/common' as pkg %}
include:
  - gentoo.makeconf
  - gentoo.portage.packages

dev-lang/python-{{ py3_slot_nodot }}:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-lang/python', slot=py3_slot) }}
    - require:
      - augeas: manage-make-conf
      - file: gentoo.portage.packages

pkg_python-config:
  pkg.latest:
    - pkgs:
      - {{ pkg.gen_atom('dev-lang/python-exec') }}
      - {{ pkg.gen_atom('app-eselect/eselect-python') }}

eselect-python:
  eselect.set:
    - name: python
    - target: "python{{ py3_slot }}"
    - require:
      - pkg: dev-lang/python-{{ py3_slot_nodot }}
      - pkg: pkg_python-config

eselect-python3:
  eselect.set:
    - name: python
    - action_parameter: '--python3'
    - target: "python{{ py3_slot }}"
    - require:
      - pkg: dev-lang/python-{{ py3_slot_nodot }}
      - pkg: pkg_python-config

app-admin/python-updater:
  pkg.purged
