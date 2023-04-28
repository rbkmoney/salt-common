{% set storage_driver = salt.pillar.get('docker:storage:driver', "overlay2") %}
{% set docker_ramdisk = salt.pillar.get('docker:storage:ramdisk', False) %}
{% if storage_driver == "devicemapper" %}
{% if docker_ramdisk %}
{% set thinpooldev = 'ramdisk--vg-docker--data' %}
{% else %}
{% set thinpooldev = salt.pillar.get('docker:storage:dm:thinpooldev', False) %}
{% endif %}
{% endif %}

{% set bip = salt.pillar.get('docker:network-simple:'+grains['fqdn']+':bip', False) %}
{% set cidr = salt.pillar.get('docker:network-simple:'+grains['fqdn']+':fixed-cidr', False) %}
{% set cidr_v6 = salt.pillar.get('docker:network-simple:'+grains['fqdn']+':fixed-cidr-v6', False) %}

{% set userns = salt.pillar.get('docker:userns', {}) %}
{% set userns_enabled = userns.get('enable', False) %}
{% set userns_user = userns.get('username', 'dockerns') %}
{% set userns_uid = userns.get('id', '100000') %}
{% set userns_uid_count = userns.get('id_count', '65536') %}

/etc/docker/:
  file.directory:
    - create: True

/etc/docker/daemon.json:
  file.serialize:
    {% if salt.pillar.get('docker:daemon', False) %}
    - dataset_pillar: 'docker:daemon'
    {% else %}
    - dataset:
        exec-opts:
          - "native.cgroupdriver={{ 'systemd' if grains.init == 'systemd' else 'cgroupfs' }}"
        log-driver: {{ salt.pillar.get('docker:log:driver', 'json-file') }}
        log-opts:
          max-size: {{ salt.pillar.get('docker:log:max-size', '50m') }}
        live-restore: {{ salt.pillar.get('docker:live-restore', True) }}
        default-ulimit: "nofile={{ salt.pillar.get('docker:default-ulimit:nofile', '65536:131072') }}"
        storage-driver: {{ storage_driver }}
        {% if bip %}
        bip: {{ bip }}
        {% endif %}
        {% if cidr %}
        fixed-cidr: {{ cidr }}
        {% endif %}
        {% if cidr_v6 %}
        ipv6: true
        fixed-cidr-v6: {{ cidr_v6 }}
        {% endif %}
        {% if userns_enabled %}
        userns-remap: "{{ userns_user }}:{{ userns_user }}"
        {% endif %}
        {% if storage_driver == "devicemapper" %}
        storage-opts:
          - "dm.fs=xfs"
          - "dm.mountpoint=discard"
          - "dm.thinpooldev={{ thinpooldev }}"
        {% endif %}
    {% endif %}
    - formatter: json
    - require:
      - file: /etc/docker/

{% if grains.init == 'systemd' %}
/etc/conf.d/docker:
  file.absent
{% else %}
/etc/conf.d/docker:
  file.managed:
    - source: salt://{{ slspath }}/files/docker.confd.tpl
    - template: jinja
    - defaults:
        docker_ramdisk: {{ docker_ramdisk }}
    - mode: 644
    - user: root
    - group: root
{% endif %}

{% if userns_enabled %}
/etc/subuid:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - contents: |
        # Managed by Salt
        {{ userns_user }}:{{ userns_uid }}:{{ userns_uid_count }}

/etc/subgid:
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - contents: |
        # Managed by Salt
        {{ userns_user }}:{{ userns_uid }}:{{ userns_uid_count }}

{{ userns_user }}:
  group.present:
    - gid: {{ userns_uid }}
  user.present:
    - fullname: "Docker remapping user"
    - shell: /bin/false
    - home: /dev/null
    - uid: {{ userns_uid }}
    - gid: {{ userns_uid }}
    - createhome: False
    - watch:
      - group: {{ userns_user }}
    - watch_in:
      - service: docker
{% endif %}
