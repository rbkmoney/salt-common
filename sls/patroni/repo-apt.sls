{% set os = grains.os.lower() %}
{% set oscodename = grains.oscodename %}
{% set mirror_host = salt.pillar.get("ubuntu:mirror:host") %}
{% set mirror_trusted = salt.pillar.get("ubuntu:mirror:trusted", False) %}

include:
  - apt.common

/etc/apt/sources.list.d/patroni.sources:
  file.managed:
    - contents: |
        Description: Patroni repo proxy
        Enabled: yes
        Types: deb
        URIs: {{ mirror_host }}/repository/pgdg-{{ oscodename }}-proxy/
        {% if mirror_trusted %}
        Trusted: yes
        {% endif %}
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
