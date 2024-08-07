include:
  - .pkg
  - .service

{% if grains['init'] == 'openrc' %}
/etc/conf.d/filebeat:
  file.append:
    - text: "export GODEBUG=x509ignoreCN=0"
    - require: 
      - pkg: app-admin/filebeat
{% elif grains['init'] == 'systemd' %}
/etc/conf.d/filebeat: file.absent
{% endif %}

extend:
  filebeat:
    service.running:
      - watch:
        - pkg: app-admin/filebeat
        - file: /etc/conf.d/filebeat
