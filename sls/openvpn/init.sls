include:
  - .pkg

/etc/openvpn/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

{% for instance,data in salt.pillar.get("openvpn:instance", {}).items() %}
/etc/openvpn/{{ instance }}.conf:
  file.managed:
    - contents_pillar: openvpn:instance:{{ instance }}:conf
    - mode: 640
    - user: root
    - group: root
    - watch_in:
      - service: openvpn.{{ instance }}

/etc/openvpn/{{ instance }}/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

{% if "cacert" in data %}
{% if data["cacert"] == "vault" %}{% set cacert_pillar = False %}{% set cacert_vault = True %}
{% else %}{% set cacert_pillar = True %}{% set cacert_vault = False %}{% endif %}
{% else %}{% set cacert_pillar = False %}{% set cacert_vault = False %}{% endif %}
/etc/openvpn/{{ instance }}/cacert.pem:
  {% if cacert_pillar %}
  file.managed:
    - contents_pillar: openvpn:instance:{{ instance }}:cacert
    - show_changes: False
    - mode: 644
    - user: root
    - group: root
    - watch_in:
      - service: openvpn.{{ instance }}
  {% else %}
  file.absent:
  {% endif %}
    - require:
      - file: /etc/openvpn/{{ instance }}/

{% if "cert" in data %}
{% if data["cert"] == "vault" %}{% set cert_pillar = False %}{% set cert_vault = True %}
{% else %}{% set cert_pillar = True %}{% set cert_vault = False %}{% endif %}
{% else %}{% set cert_pillar = False %}{% set cert_vault = False %}{% endif %}
/etc/openvpn/{{ instance }}/cert.pem:
  {% if data.get("cert", False) and data["cert"] != "vault" %}
  file.managed:
    - contents_pillar: openvpn:instance:{{ instance }}:cert
    - show_changes: False
    - mode: 644
    - user: root
    - group: root
    - watch_in:
      - service: openvpn.{{ instance }}
  {% else %}
  file.absent:
  {% endif %}
    - require:
      - file: /etc/openvpn/{{ instance }}/


{% if "privkey" in data %}
{% if data["privkey"] == "vault" %}{% set privkey_pillar = False %}{% set privkey_vault = True %}
{% else %}{% set privkey_pillar = True %}{% set privkey_vault = False %}{% endif %}
{% else %}{% set privkey_pillar = False %}{% set privkey_vault = False %}{% endif %}
/etc/openvpn/{{ instance }}/privkey.pem:
  {% if data.get("privkey", False) and data["privkey"] != "vault" %}
  file.managed:
    - contents_pillar: openvpn:instance:{{ instance }}:privkey
    - show_changes: False
    - mode: 600
    - user: root
    - group: root
    - watch_in:
      - service: openvpn.{{ instance }}
  {% else %}
  file.absent:
  {% endif %}
    - require:
      - file: /etc/openvpn/{{ instance }}/

{% if "crl" in data %}
{% if data["crl"] == "vault" %}{% set crl_pillar = False %}{% set crl_vault = True %}
{% else %}{% set crl_pillar = True %}{% set crl_vault = False %}{% endif %}
{% else %}{% set crl_pillar = False %}{% set crl_vault = False %}{% endif %}
/etc/openvpn/{{ instance }}/crl.pem:
  {% if data.get("crl", False) and data["crl"] != "vault" %}
  file.managed:
    - contents_pillar: openvpn:instance:{{ instance }}:crl
    - show_changes: False
    - mode: 600
    - user: root
    - group: root
    - watch_in:
      - service: openvpn.{{ instance }}
  {% else %}
  file.absent:
  {% endif %}
    - require:
      - file: /etc/openvpn/{{ instance }}/

{% if "dh" in data %}
{% if data["dh"] == "vault" %}{% set dh_pillar = False %}{% set dh_vault = True %}
{% else %}{% set dh_pillar = True %}{% set dh_vault = False %}{% endif %}
{% else %}{% set dh_pillar = False %}{% set dh_vault = False %}{% endif %}
/etc/openvpn/{{ instance }}/dh.pem:
  {% if data.get("dh", False) and data["dh"] != "vault" %}
  file.managed:
    - contents_pillar: openvpn:instance:{{ instance }}:dh
    - show_changes: False
    - mode: 644
    - user: root
    - group: root
    - watch_in:
      - service: openvpn.{{ instance }}
  {% else %}
  file.absent:
  {% endif %}
    - require:
      - file: /etc/openvpn/{{ instance }}/

{% if "takey" in data %}
{% if data["takey"] == "vault" %}{% set takey_pillar = False %}{% set takey_vault = True %}
{% else %}{% set takey_pillar = True %}{% set takey_vault = False %}{% endif %}
{% else %}{% set takey_pillar = False %}{% set takey_vault = False %}{% endif %}
/etc/openvpn/{{ instance }}/takey.pem:
  {% if data.get("takey", False) and data["takey"] != "vault" %}
  file.managed:
    - contents_pillar: openvpn:instance:{{ instance }}:takey
    - show_changes: False
    - mode: 640
    - user: root
    - group: root
    - watch_in:
      - service: openvpn.{{ instance }}
  {% else %}
  file.absent:
  {% endif %}
    - require:
      - file: /etc/openvpn/{{ instance }}/

{% if "tls-crypt" in data %}
{% if data["tls-crypt"] == "vault" %}{% set tls_crypt_pillar = False %}{% set tls_crypt_vault = True %}
{% else %}{% set tls_crypt_pillar = True %}{% set tls_crypt_vault = False %}{% endif %}
{% else %}{% set tls_crypt_pillar = False %}{% set tls_crypt_vault = False %}{% endif %}
/etc/openvpn/{{ instance }}/tls-crypt.pem:
  {% if data.get("tls-crypt", False) and data["tls-crypt"] != "vault" %}
  file.managed:
    - contents_pillar: openvpn:instance:{{ instance }}:tls-crypt
    - show_changes: False
    - mode: 640
    - user: root
    - group: root
    - watch_in:
      - service: openvpn.{{ instance }}
  {% else %}
  file.absent:
  {% endif %}
    - require:
      - file: /etc/openvpn/{{ instance }}/

/etc/openvpn/{{ instance }}/ipp.txt:
  file.managed:
    - replace: False
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/openvpn/{{ instance }}/
    - watch_in:
      - service: openvpn.{{ instance }}

{% if "ccd" in data %}
/etc/openvpn/{{ instance }}/ccd/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /etc/openvpn/{{ instance }}/
    - watch_in:
      - service: openvpn.{{ instance }}
{% endif %}

{% if grains['init'] == 'openrc' %}
/etc/init.d/openvpn.{{ instance }}:
  file.symlink:
    - target: openvpn
    - watch_in:
      - service: openvpn.{{ instance }}
{% elif grains['init'] == 'systemd' %}
/etc/init.d/openvpn.{{ instance }}: file.absent
{% endif %}

openvpn.{{ instance }}:
  {% if data.get("enabled", False) %}
  service.running:
    - enable: true
  {% else %}
  service.dead:
  {% endif %}
  {% if grains['init'] == 'systemd' %}
    - name: openvpn@{{ instance }}.service
  {% endif %}
    - watch:
      - file: /etc/openvpn/{{ instance }}.conf
      - file: /etc/openvpn/{{ instance }}/
{% endfor %}
