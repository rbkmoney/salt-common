salt-repo:
  pkgrepo.managed:
    - name: >
        deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg arch={{ grains.osarch }}]
        https://repo.saltproject.io/py3/ubuntu/{{ grains.osrelease }}/{{ grains.osarch }}/latest
        {{ grains.lsb_distrib_codename }} main
    - humanname: SaltStack
    - file: /etc/apt/sources.list.d/salt.list
    - require:
      - file: /usr/share/keyrings/salt-archive-keyring.gpg

/usr/share/keyrings/salt-archive-keyring.gpg:
  file.managed:
    - source: salt://{{ slspath }}/files/ubuntu-{{ grains.osrelease }}-salt-archive-keyring.gpg
