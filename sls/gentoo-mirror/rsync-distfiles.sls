include:
  - nginx
  - nginx.tls.gentoo-mirror
  - rsyncd
  - cron
  - logrotate

{% set mirror_host = salt['pillar.get']('gentoo-mirror:mirror-host', 'gentoo.bakka.su') %}
{% set dst_host = salt['pillar.get']('gentoo-mirror:dst-host',
      'gentoo.'+salt['grains.get']('domain', 'localdomain')) %}
{% set default_root = "/var/storage/mirrors" %}
{% set mirror_types = salt['pillar.get']('gentoo-mirror:types', []) %}

# TODO: cron jobs randomizaton/pillar

/etc/nginx/vhosts.d/gentoo-mirror.conf:
  file.managed:
    - source: salt://{{ slspath }}/files/gentoo_mirror.nginx.conf.tpl
    - template: jinja
    - defaults:
        ssl: True
        ssl_cert_path: /etc/ssl/nginx/gentoo-mirror/certificate.pem
        ssl_key_path: /etc/ssl/nginx/gentoo-mirror/privkey.pem
        server_name: {{ dst_host }}
        document_root: {{ default_root }}
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/ssl/nginx/gentoo-mirror/certificate.pem
      - file: /etc/ssl/nginx/gentoo-mirror/privkey.pem
    - watch_in:
      - service: nginx-reload

/opt/gentoo-mirror/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/opt/gentoo-mirror/rsync-base.sh:
  file.managed:
    - source: salt://{{ slspath }}/files/rsync-base.sh
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /opt/gentoo-mirror/

/etc/gentoo-mirror/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/var/log/gentoo-mirror/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/etc/logrotate.d/gentoo-mirror:
  file.managed:
    - source: salt://{{ slspath }}/files/gentoo-mirror.logrotate
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/logrotate.d/

{% if 'gentoo-distfiles' in mirror_types %}
"{{ default_root }}/gentoo-distfiles":
  file.directory:
    - create: True
    - makedirs: True

/etc/gentoo-mirror/rsync-gentoo-distfiles.conf:
  file.managed:
    - source: salt://{{ slspath }}/files/rsync-conf.tpl
    - template: jinja
    - defaults:
        rsync_src: "rsync://{{ mirror_host }}/gentoo-distfiles"
        rsync_dst: "{{ default_root }}/gentoo-distfiles"
    # - context:

/opt/gentoo-mirror/rsync-gentoo-distfiles.sh:
  file.symlink:
    - target: /opt/gentoo-mirror/rsync-base.sh
    - require:
      - file: /opt/gentoo-mirror/rsync-base.sh

rsync-gentoo-distfiles:
  cron.present:
    - identifier: rsync-gentoo-distfiles
    - name: /opt/gentoo-mirror/rsync-gentoo-distfiles.sh
    - user: root
    - minute: 0
    - hour: '*/4'
    - require:
      - file: /etc/gentoo-mirror/rsync-gentoo-distfiles.conf
      - file: /opt/gentoo-mirror/rsync-gentoo-distfiles.sh

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

/etc/gentoo-mirror/rsync-gentoo-portage.conf:
  file.managed:
    - source: salt://{{ slspath }}/files/rsync-conf.tpl
    - template: jinja
    - defaults:
        rsync_src: "rsync://{{ mirror_host }}/gentoo-portage"
        rsync_dst: "{{ default_root }}/gentoo-portage"
        rsync_opts: "+ --checksums"
    # - context:

/opt/gentoo-mirror/rsync-gentoo-portage.sh:
  file.symlink:
    - target: /opt/gentoo-mirror/rsync-base.sh
    - require:
      - file: /opt/gentoo-mirror/rsync-base.sh

rsync-gentoo-portage:
  cron.present:
    - identifier: rsync-gentoo-portage
    - name: /opt/gentoo-mirror/rsync-gentoo-portage.sh
    - user: root
    - minute: 0
    - hour: '*/4'
    - require:
      - file: /etc/gentoo-mirror/rsync-gentoo-portage.conf
      - file: /opt/gentoo-mirror/rsync-gentoo-portage.sh

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

{% for inst in salt['pillar.get']('gentoo-mirror:gentoo-package-repos', []) %}
/opt/gentoo-mirror/rsync-gentoo-{{ inst['arch'] }}-{{ inst['cpu_arch'] }}-packages.sh:
  file.symlink:
    - target: /opt/gentoo-mirror/rsync-base.sh
    - require:
      - file: /opt/gentoo-mirror/rsync-base.sh

"{{ default_root }}/{{ inst.get('rsync_dst', 'gentoo-packages/'+inst['arch']+'/'+inst['cpu_arch']) }}":
  file.directory:
    - create: True
    - makedirs: True
        
/etc/gentoo-mirror/rsync-gentoo-{{ inst['arch'] }}-{{ inst['cpu_arch'] }}-packages.conf:
  file.managed:
    - source: salt://{{ slspath }}/files/rsync-conf.tpl
    - template: jinja
    - defaults:
        rsync_src: "{{ inst.get('rsync_src', 'rsync://'+mirror_host+'/gentoo-packages/'+inst['arch']+'/'+inst['cpu_arch']) }}"
        rsync_dst: "{{ default_root }}/{{ inst.get('rsync_dst', 'gentoo-packages/'+inst['arch']+'/'+inst['cpu_arch']) }}"

rsync-gentoo-{{ inst['arch'] }}-{{ inst['cpu_arch'] }}-packages:
  cron.present:
    - identifier: rsync-gentoo-{{ inst['arch'] }}-{{ inst['cpu_arch'] }}-packages
    - name: /opt/gentoo-mirror/rsync-gentoo-{{ inst['arch'] }}-{{ inst['cpu_arch'] }}-packages.sh
    - user: root
    - dayweek: "{{ inst.get('day','*') }}"
    - hour: "{{ inst.get('hour','*/4') }}"
    - minute: "{{ inst.get('minute','0') }}"
    - require:
      - file: /etc/gentoo-mirror/rsync-gentoo-{{ inst['arch'] }}-{{ inst['cpu_arch'] }}-packages.conf
      - file: /opt/gentoo-mirror/rsync-gentoo-{{ inst['arch'] }}-{{ inst['cpu_arch'] }}-packages.sh

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
