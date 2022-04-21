/etc/apt/sources.list.d/consul.list:
  file.managed:
    - contents: |
        deb [signed-by=/usr/share/keyrings/consul-archive-keyring.gpg arch=amd64] https://apt.releases.hashicorp.com {{ grains.lsb_distrib_codename }} main

/usr/share/keyrings/consul-archive-keyring.gpg:
  file.managed:
    - source: salt://{{ slspath }}/files/consul-archive-keyring.gpg

app-admin/consul:
  pkg.installed:
    - name: consul
    - require:
      - file: /etc/apt/sources.list.d/consul.list
      - file: /usr/share/keyrings/consul-archive-keyring.gpg

