include:
  - augeas.lenses
  - fonts.terminus

manage-consolefont:
  augeas.change:
    - context: /files/etc/conf.d/consolefont
    - lens: Shellvars.lns
    - require:
      - file: augeas-confd
      - pkg: terminus
    - changes:
      - set consolefont '"ter-v14n"'

consolefont_service:
  service.running:
    - name: consolefont
    - enable: True
    - watch:
      - augeas: manage-consolefont
