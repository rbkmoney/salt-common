/etc/apt/sources.list.d/hashicorp.list:
  file.managed:
    - contents: |
        deb [signed-by=/usr/share/keyrings/hashicorp.gpg arch=amd64] https://apt.releases.hashicorp.com {{ grains.lsb_distrib_codename }} main

/usr/share/keyrings/hashicorp.gpg:
  file.managed:
    - source: salt://{{ slspath }}/files/hashicorp.gpg
