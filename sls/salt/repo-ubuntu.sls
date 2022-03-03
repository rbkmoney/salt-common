/etc/apt/sources.list.d/salt.list:
  file.present:
    - contents: |
        deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg arch=amd64] https://repo.saltproject.io/py3/ubuntu/{{ grains.osrelease }}/amd64/latest focal main

/usr/share/keyrings/salt-archive-keyring.gpg:
  file.present:
    - source: salt://{{ slspath }}/files/ubuntu-{{ grains.osrelease }}-salt-archive-keyring.gpg
