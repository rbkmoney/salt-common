include:
  - python.python37

eselect-python3:
  eselect.set:
    - name: python
    - action_parameter: '--python3'
    - target: 'python3.7'
    - require:
      - pkg: python37
