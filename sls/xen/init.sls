# -*- mode: yaml -*-
{% set efi = salt['grains.get']('efi', False) %}
{% set xen_provided = salt['grains.get']('xen_provided', False) %}
{% set xen_version = salt['grains.get']('xen_version', '4.6.1-r2' %}
{% set xen_version_short = xen_version.split('-')[0] %}

include:
  - gentoo.portage
  - qemu
  {% if efi %}
  - fs.efi
  {% endif %}

/etc/portage/env/xen-install-mask:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        INSTALL_MASK='/boot/xen.gz /boot/xen-4.gz /boot/xen-4.6.gz'
    - require:
      - file: /etc/portage/env/

xen:
  portage_config.flags:
    - name: app-emulation/xen
    - use: [{{ 'efi' if efi else '-efi' }}]
    - env:
      - xen-install-mask
    - require:
      - file: /etc/portage/env/xen-install-mask
  pkg.installed:
    - pkgs:
      {% if not xen_provided %}
      - app-emulation/xen: "~={{ xen_version }}[{{ 'efi' if efi else '-efi' }}]"
      {% endif %}
      - app-emulation/xen-tools: "~>=4.6.1[api,hvm,screen,system-qemu,system-seabios]"
      - dev-libs/libnl
    - require:
      - pkg: qemu
      - portage_config: xen
      - file: unmask-hvm
      {% if xen_provided %}
      - file: xen-provided
      {% endif %}

{% if xen_provided %}
xen-provided:
  file.append:
    - name: /etc/portage/profile/package.provided
    - text: "app-emulation/xen-{{ xen_version }}"
{% else %}
{% if efi %}
xen.efi:
  file.copy:
    - name: /boot/efi/gentoo/xen.efi
    - source: /boot/efi/gentoo/xen-{{ xen_version_short }}.efi
{% else %}
xen.gz:
  file.copy:
    - name: /boot/xen.gz
    - source: /boot/xen-{{ xen_version_short }}.gz
{% endif %}
{% endif %}

unmask-hvm:
  file.append:
    - name: /etc/portage/profile/use.mask
    - text: "-hvm"

xencommons:
  service.running:
    - enable: True

xenstored:
  service.running:
    - enable: True

xenconsoled:
  service.running:
    - enable: True

{% for br in salt['pillar.get']('xen:xenbrs', []) %}
/etc/init.d/net.xenbr{{ br.num }}:
  file.symlink:
    - target: /etc/init.d/net.lo
      
net.xenbr{{ br.num }}:
  service.running:
    - enable: True
    - require:
      - file: /etc/init.d/net.xenbr{{ br.num }}
{% endfor %}

/etc/xen/xl.conf:
  file.managed:
    - source: salt://xen/xl.conf
    - mode: 644
    - user: root
    - group: root

/etc/init.d/xendomains:
  file.managed:
    - source: salt://xen/xendomains.initd
    - mode: 755
    - user: root
    - group: root

/etc/conf.d/xendomains:
  file.managed:
    - source: salt://xen/xendomains.confd.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root

/etc/xen/domains/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/etc/xen/auto/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/etc/xen/scripts/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/etc/xen/scripts/block-rbd:
  file.managed:
    - source: salt://xen/scripts/block-rbd
    - mode: 755
    - user: root
    - group: root    

xendomains:
  service.running:
    - enable: True
    - watch:
      - file: /etc/init.d/xendomains
      - file: /etc/conf.d/xendomains

bringup-xendomains:
  cron.present:
    - identifier: bringup-xendomains
    - name: "/etc/init.d/xendomains --ifstarted bringup"
    - minute: '*/10'
    - user: root
    - require:
      - service: xendomains
