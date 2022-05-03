/etc/apt/sources.list.d/salt.list:
  file.managed:
    - contents: |
        deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg arch={{ grains.osarch }}] https://repo.saltproject.io/py3/{{ grains.os.lower() }}/{{ grains.osrelease }}/{{ grains.osarch }}/latest {{ grains.lsb_distrib_codename }} main
    - require:
      - file: /usr/share/keyrings/salt-archive-keyring.gpg

/usr/share/keyrings/salt-archive-keyring.gpg:
  file.managed:
    - source: salt://{{ slspath }}/files/{{ grains.os.lower() }}-{{ grains.osrelease }}-salt-archive-keyring.gpg
