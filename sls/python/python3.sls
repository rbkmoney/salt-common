include:
  - python.python38

eselect-python3:
  eselect.set:
    - name: python
    - action_parameter: '--python3'
    - target: 'python3.8'
    - require:
      - pkg: python38
