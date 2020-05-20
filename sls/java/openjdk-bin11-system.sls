include:
  - .openjdk-bin11

set-java-system-vm:
  eselect.set:
    - name: java-vm
    - target: openjdk-bin-11
    - action_parameter: system
    - require:
      - pkg: dev-java/openjdk-bin
