/etc/apt/sources.list.d/hashicorp.list:
  file.managed:
    - contents: |
        deb [signed-by=/usr/share/keyrings/hashicorp.gpg arch=amd64] https://apt.releases.hashicorp.com {{ grains.lsb_distrib_codename }} main
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /usr/share/keyrings/hashicorp.gpg

/usr/share/keyrings/hashicorp.gpg:
  file.managed:
    - source: salt://{{ slspath }}/files/hashicorp.gpg
    - user: root
    - group: root
    - mode: 644
