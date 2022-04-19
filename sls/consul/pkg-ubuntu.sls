/etc/apt/sources.list.d/consul.list:
  file.managed:
    - contents: |
        deb [signed-by=/usr/share/keyrings/hashicorp.gpg arch=amd64]  http://51.250.31.91/hashicorp/mirror/apt.releases.hashicorp.com focal main restricted

/usr/share/keyrings/hashicorp.gpg:
  file.managed:
    - source: salt://{{ slspath }}/files/hashicorp.gpg

app-admin/consul:
  pkg.installed:
    - name: consul
    - require:
      - file: /etc/apt/sources.list.d/consul.list
      - file: /usr/share/keyrings/hashicorp.gpg

