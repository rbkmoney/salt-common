{% import 'pkg/common' as pkg %}
# This definitely should be set
{% set packages = salt['pillar.get']('gentoo:portage:packages', {}) %}
{% set packages_xen = packages.get('app-emulation/xen', {}) %}
{% set packages_xen_tools = packages.get('app-emulation/xen-tools', {}) %}
{% set xen_version = packages_xen.get('version', '4.13*') %}
{% set xen_tools_version = packages_xen_tools.get('version', '4.13*') %}
{% set xen_version_short = xen_version.rsplit('-', 1)[0].strip('-~*<>=') %}
{% set efi = salt['grains.get']('efi', False) %}
# This should be set when we shall not install xen from here;
# For example when the xen binary is fetched from a tftp server.
{% set xen_provided = salt['grains.get']('xen_provided', False) %}
{% set xen_packaged = salt['pillar.get']('xen:packaged', False) %}
{% set kernels_remote = salt['pillar.get']('xen:kernels:remote', False) -%}

include:
  - gentoo.portage
  - xen.bridgeconfig
  - xen.domainconfig

/etc/portage/env/xen-install-mask:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        INSTALL_MASK='/boot/xen.gz /boot/xen-4.gz /boot/xen-{{ xen_version_short }}.gz'
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
      - app-emulation/xen: "{{ xen_version }}[{{ 'efi' if efi else '-efi' }}]"
      {% endif %}
      - app-emulation/xen-tools: "{{ xen_tools_version }}[api,hvm,screen,system-qemu,-qemu,system-seabios]"
      - {{ pkg.gen_atom('app-emulation/qemu') }}
      - {{ pkg.gen_atom('dev-libs/libnl') }}
    {% if xen_packaged %}
    - binhost: force
    {% endif %}
    - require:
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
/boot/efi/xen.efi:
  file.copy:
    - source: /usr/lib64/efi/xen-{{ xen_version_short }}.efi
    - mode: 755
{% endif %}
{% endif %}

unmask-hvm:
  file.append:
    - name: /etc/portage/profile/use.mask
    - text: "-hvm"

/etc/xen/xl.conf:
  file.managed:
    - source: salt://xen/files/xl.conf
    - mode: 644
    - user: root
    - group: root

/etc/init.d/xendomains:
  file.managed:
    - source: salt://xen/files/xendomains.initd
    - mode: 755
    - user: root
    - group: root

/etc/conf.d/xendomains:
  file.managed:
    - source: salt://xen//files/xendomains.confd.tpl
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

/var/xen/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/var/xen/kernels/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: /var/xen/

{% if kernels_remote and kernels_remote['type'] == 'git' %}
/root/.ssh/xen-kernels-access:
  file.managed:
    - source: salt://ssl/openssh-privkey.tpl
    - template: jinja
    - context:
        privkey_key: xen-kernels-access
    - mode: 600
    - user: root

fetch-kernels:
  git.latest:
    - name: {{ kernels_remote['uri'] }}
    - target: /var/xen/kernels/
    - rev: master
    - force_clone: True
    - force_checkout: True
    - identity: /root/.ssh/xen-kernels-access
    - require:
      - file: /var/xen/kernels/
      - file: /root/.ssh/xen-kernels-access
{% endif %}

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
