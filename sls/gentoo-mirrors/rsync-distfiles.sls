# -*- mode: yaml -*-
include:
  - nginx
  - rsyncd
  - cron

{% set mirror_host = salt['pillar.get']('gentoo-mirror:mirror-host', 'gentoo.bakka.su') %}
{% set dst_host = salt['pillar.get']('gentoo-mirror:dst-host',
      'gentoo.'+salt['grains.get']('domain', 'localdomain')) %}
{% set default_root = "/var/storage/mirrors" %}
{% set mirror_types = salt['pillar.get']('gentoo-mirror:types', []) %}

# TODO: cron jobs randomizaton/pillar

/etc/ssl/nginx/gentoo-mirror/:
  file.directory:
    - create: True
    - mode: 750
    - user: root
    - group: nginx

/etc/ssl/nginx/gentoo-mirror/certificate.pem:
  file.managed:
    - source: salt://ssl/certificate-chain.tpl
    - template: jinja
    - defaults:
        cert_chain_key: 'gentoo-mirror'
    - mode: 644
    - user: root
    - group: nginx
    - watch_in:
      - service: nginx-reload

/etc/ssl/nginx/gentoo-mirror/privkey.pem:
  file.managed:
    - source: salt://ssl/privkey.tpl
    - template: jinja
    - defaults:
        privkey_key: 'gentoo-mirror'
    - mode: 600
    - user: root
    - group: root
    - watch_in:
      - service: nginx-reload

/etc/nginx/vhosts.d/gentoo-mirror.conf:
  file.managed:
    - source: salt://gentoo-mirrors/gentoo_mirror.nginx.conf.tpl
    - template: jinja
    - defaults:
        ssl: False
        server_name: {{ dst_host }}
        document_root: {{ default_root }}
    - context:
        ssl: True
        ssl_cert_path: /etc/ssl/nginx/gentoo-mirror/certificate.pem
        ssl_key_path: /etc/ssl/nginx/gentoo-mirror/privkey.pem
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/ssl/nginx/gentoo-mirror/certificate.pem
      - file: /etc/ssl/nginx/gentoo-mirror/certificate.pem
    - watch_in:
      - service: nginx-reload

/opt/gentoo-rsync/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/opt/gentoo-rsync/rsync-base.sh:
  file.managed:
    - source: salt://gentoo-mirrors/rsync-base.sh
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /opt/gentoo-rsync/

/etc/rsync/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

{% if 'gentoo-distfiles' in mirror_types %}
"{{ default_root }}/gentoo-distfiles":
  file.directory:
    - create: True
    - makedirs: True

/etc/rsync/rsync-gentoo-distfiles.conf:
  file.managed:
    - source: salt://gentoo-mirrors/rsync-conf.tpl
    - template: jinja
    - defaults:
        rsync_src: "rsync://{{ mirror_host }}/gentoo-distfiles"
        rsync_dst: "{{ default_root }}/gentoo-distfiles"
    # - context:

/opt/gentoo-rsync/rsync-gentoo-distfiles.sh:
  file.symlink:
    - target: /opt/gentoo-rsync/rsync-base.sh
    - require:
      - file: /opt/gentoo-rsync/rsync-base.sh

rsync-gentoo-distfiles:
  cron.present:
    - identifier: rsync-gentoo-distfiles
    - name: /opt/gentoo-rsync/rsync-gentoo-distfiles.sh
    - user: root
    - minute: 0
    - hour: '*/4'
    - require:
      - file: /etc/rsync/rsync-gentoo-distfiles.conf
      - file: /opt/gentoo-rsync/rsync-gentoo-distfiles.sh

/etc/rsyncd.d/gentoo-distfiles.conf:
  ini.options_present:
    - sections:
        'gentoo-distfiles':
          path: "{{ default_root }}/gentoo-distfiles"
          comment: "Gentoo Linux distfiles mirror"
    - watch_in:
      - service: rsyncd
{% endif %}

{% if 'gentoo-portage' in mirror_types %}
"{{ default_root }}/gentoo-portage":
  file.directory:
    - create: True
    - makedirs: True

/etc/rsync/rsync-gentoo-portage.conf:
  file.managed:
    - source: salt://gentoo-mirrors/rsync-conf.tpl
    - template: jinja
    - defaults:
        rsync_src: "rsync://{{ mirror_host }}/gentoo-portage"
        rsync_dst: "{{ default_root }}/gentoo-portage"
        rsync_opts: "+ --checksums"
    # - context:

/opt/gentoo-rsync/rsync-gentoo-portage.sh:
  file.symlink:
    - target: /opt/gentoo-rsync/rsync-base.sh
    - require:
      - file: /opt/gentoo-rsync/rsync-base.sh

rsync-gentoo-portage:
  cron.present:
    - identifier: rsync-gentoo-portage
    - name: /opt/gentoo-rsync/rsync-gentoo-portage.sh
    - user: root
    - minute: 0
    - hour: '*/4'
    - require:
      - file: /etc/rsync/rsync-gentoo-portage.conf
      - file: /opt/gentoo-rsync/rsync-gentoo-portage.sh

/etc/rsyncd.d/gentoo-portage.conf:
  ini.options_present:
    - sections:
        'gentoo-portage':
          path: "{{ default_root }}/gentoo-portage"
          comment: "Gentoo Linux Portage tree mirror"
          exclude: "/.git"
    - watch_in:
      - service: rsyncd
{% endif %}

{% if 'packages' in mirror_types %}
"{{ default_root }}/gentoo-packages":
  file.directory:
    - create: True
    - makedirs: True

{% for inst in salt['pillar.get']('mirror:gentoo-package-repos', []) %}
/opt/gentoo-rsync/rsync-gentoo-{{ inst['arch'] }}-{{ inst['cpu_arch'] }}-packages.sh:
  file.symlink:
    - target: /opt/gentoo-rsync/rsync-base.sh
    - require:
      - file: /opt/gentoo-rsync/rsync-base.sh

"{{ default_root }}/{{ inst.get('rsync_dst', 'gentoo-packages/'+inst['arch']+'/'+inst['cpu_arch']) }}":
  file.directory:
    - create: True
    - makedirs: True
        
/etc/rsync/rsync-gentoo-{{ inst['arch'] }}-{{ inst['cpu_arch'] }}-packages.conf:
  file.managed:
    - source: salt://gentoo-mirrors/rsync-conf.tpl
    - template: jinja
    - defaults:
        rsync_src: "{{ inst.get('rsync_src', 'rsync://'+mirror_host+'/gentoo-packages/'+inst['arch']+'/'+inst['cpu_arch']) }}"
        rsync_dst: "{{ default_root }}/{{ inst.get('rsync_dst', 'gentoo-packages/'+inst['arch']+'/'+inst['cpu_arch']) }}"

rsync-gentoo-{{ inst['arch'] }}-{{ inst['cpu_arch'] }}-packages:
  cron.present:
    - identifier: rsync-gentoo-{{ inst['arch'] }}-{{ inst['cpu_arch'] }}-packages
    - name: /opt/gentoo-rsync/rsync-gentoo-{{ inst['arch'] }}-{{ inst['cpu_arch'] }}-packages.sh
    - user: root
    - dayweek: "{{ inst.get('day','*') }}"
    - hour: "{{ inst.get('hour','*/4') }}"
    - minute: "{{ inst.get('minute','0') }}"
    - require:
      - file: /etc/rsync/rsync-gentoo-{{ inst['arch'] }}-{{ inst['cpu_arch'] }}-packages.conf
      - file: /opt/gentoo-rsync/rsync-gentoo-{{ inst['arch'] }}-{{ inst['cpu_arch'] }}-packages.sh

/etc/rsyncd.d/gentoo-{{ inst['arch'] }}-{{ inst['cpu_arch'] }}-packages.conf:
  ini.options_present:
    - sections:
        'gentoo-{{ inst['arch'] }}-{{ inst['cpu_arch'] }}-packages':
          path: "{{ default_root }}/{{ inst.get('rsync_dst', 'gentoo-packages/'+inst['arch']+'/'+inst['cpu_arch']) }}"
          comment: "Gentoo Linux {{ inst['arch'] }}-{{ inst['cpu_arch'] }} packages repo"
    - watch_in:
      - service: rsyncd
{% endfor %}
{% endif %}
