{% if grains['init'] == 'openrc' %}
/etc/conf.d/hostname:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        # Managed by Salt
        # Set to the hostname of this machine
        hostname="{{ grains['fqdn'] }}"

hostname:
  service.running:
    - watch:
      - file: /etc/conf.d/hostname

{% else %}
/etc/conf.d/hostname:
  file.absent

/etc/hostname:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: {{ grains['fqdn'] }}
{% endif %}

set-fqdn:
  cmd.run:
    {% if grains['init'] == 'systemd' %}
    - name: hostnamectl set-hostname {{ hostname }}
    {% else %}
    - name: hostname {{ hostname }}
    {% endif %}
    - unless: test "{{ hostname }}" = "$(hostname)"
