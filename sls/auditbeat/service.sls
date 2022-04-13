auditd:
  service.dead:
    - enable: False

auditbeat:
  service.running:
    - enable: True
    - require:
      - service: auditd

