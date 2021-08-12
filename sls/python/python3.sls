include:
  - python.python39

eselect-python3:
  eselect.set:
    - name: python
    - action_parameter: '--python3'
    - target: 'python3.9'
    - require:
      - pkg: python39
