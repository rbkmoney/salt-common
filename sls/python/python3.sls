include:
  - gentoo.makeconf
  - python.python36

eselect-python3:
  eselect.set:
    - name: python
    - action_parameter: '--python3'
    - target: 'python3.6'
    - require:
      - pkg: python36
