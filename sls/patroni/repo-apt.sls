{% set os = grains.os.lower() %}
{% set oscodename = grains.oscodename %}
include:
  - apt.common

/etc/apt/sources.list.d/patroni.sources:
  file.managed:
    - contents: |
        Description: Patroni repo proxy
        Enabled: yes
        Types: deb
        URIs: https://mirror-prd-001.dc1.xpay.local/repository/pgdg-{{ oscodename }}-proxy/
        Suites: {{ oscodename }}-pgdg
        Components: main
        Signed-By: /etc/apt/keyrings/patroni-apt-keyring.pgp
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/apt/sources.list.d/
      - file: /etc/apt/keyrings/patroni-apt-keyring.pgp

/etc/apt/keyrings/patroni-apt-keyring.pgp:
  file.managed:
    - source: salt://{{ slspath }}/files/patroni-apt-keyring.pgp
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/apt/keyrings/

/etc/apt/keyrings/patroni-archive-keyring.gpg:
  file.absent
