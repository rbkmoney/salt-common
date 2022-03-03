/etc/apt/sources.list.d/salt.list:
  file.managed:
    - contents: |
        deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg arch=amd64] https://repo.saltproject.io/py3/ubuntu/{{ grains.osrelease }}/amd64/latest {{ grains.lsb_distrib_codename }} main

/usr/share/keyrings/salt-archive-keyring.gpg:
  file.managed:
    - source: salt://{{ slspath }}/files/ubuntu-{{ grains.osrelease }}-salt-archive-keyring.gpg
