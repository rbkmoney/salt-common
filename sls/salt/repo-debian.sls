{% set os = grains.os.lower() %}
{% set osrelease = grains.osrelease %}
{% set lsb_distrib_codename = grains.lsb_distrib_codename %}
{% set saltversion = "3006" %}

{% if grains.os == 'Ubuntu' and grains.osmajorrelease == 23 %}
{% set osrelease = '20.04' %}
{% set lsb_distrib_codename = 'focal' %}
{% elif grains.os == 'Ubuntu' and grains.osmajorrelease == 22 %}
{% set osrelease = '20.04' %}
{% set lsb_distrib_codename = 'focal' %}
{% endif %}
{% if grains.osarch == 'arm64' and grains.os == 'Debian' and grains.osmajorrelease == 10 %}
{% set osrelease = '11' %}
{% set lsb_distrib_codename = 'bullseye' %}
{% endif %}

include:
  - apt.common

/etc/apt/sources.list.d/salt.list:
  file.managed:
    - contents: |
        deb [signed-by=/etc/apt/keyrings/salt-archive-keyring.gpg arch={{ grains.osarch }}] https://packages.broadcom.com/artifactory/saltproject-deb stable main
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/apt/keyrings/salt-archive-keyring.gpg
      - file: /etc/apt/sources.list.d/

/etc/apt/keyrings/salt-archive-keyring.gpg:
  file.managed:
    - source: salt://{{ slspath }}/files/saltproject-deb-keyring.key
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/apt/keyrings/

