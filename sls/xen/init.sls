# This definitely should be set
{% set efi = salt['grains.get']('efi', False) %}
# This should be set when we can not install xen from here;
# For example: machine is PXE booted, and you need to modify file on tftp server;
{% set xen_provided = salt['grains.get']('xen_provided', False) %}
{% set xen_version = salt['pillar.get']('xen:version', '4.7.3') %}
{% set xen_tools_version = salt['pillar.get']('xen:tools_version', '4.7.3') %}
{% set xen_version_short = xen_version.split('-')[0] %}

include:
  - gentoo.portage
  - qemu
  - xen.bridgeconfig
  - xen.domainconfig

/etc/portage/env/xen-install-mask:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        INSTALL_MASK='/boot/xen.gz /boot/xen-4.gz /boot/xen-4.6.gz /boot/xen-4.7.gz /boot/xen-4.8.gz'
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
      - app-emulation/xen: "={{ xen_version }}[{{ 'efi' if efi else '-efi' }}]"
      {% endif %}
      - app-emulation/xen-tools: "={{ xen_tools_version }}[api,hvm,screen,system-qemu,-qemu,system-seabios]"
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

xencommons:
  service.running:
    - enable: True

xenstored:
  service.running:
    - enable: True

xenconsoled:
  service.running:
    - enable: True

xendomains:
  service.running:
    - enable: True
    - watch:
      - file: /etc/init.d/xendomains
      - file: /etc/conf.d/xendomains
    - require:
      - file: /etc/xen/scripts/block-rbd
      - file: set-xenbridges-conf

bringup-xendomains:
  cron.present:
    - identifier: bringup-xendomains
    - name: "/etc/init.d/xendomains --ifstarted bringup"
    - minute: '*/10'
    - user: root
    - require:
      - service: xendomains
