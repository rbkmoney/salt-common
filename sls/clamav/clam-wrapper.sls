/usr/local/bin/clam-wrapper.py:
  file.managed:
    - source: salt://clamav/files/clam-wrapper.py
    - mode: 755
    - user: root
    - group: root
