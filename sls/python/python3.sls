include:
  - python.python36

python3:
  pkg.latest:
    - name: dev-lang/python:3.6
    - slot: '3.6'
    - watch:
      - augeas: manage-make-conf

eselect-python3:
  eselect.set:
    - name: python
    - action_parameter: '--python3'
    - target: 'python3.6'
    - require:
      - pkg: pkg_python-config

