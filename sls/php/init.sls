# -*- mode: yaml -*-
{% from "php/map.jinja" import php_config with context %}
{% set php_version = php_config['version'] %}

{% if grains['os_family'] == 'Gentoo' %}
include:
  - augeas.lenses

manage-php-ini-version:
  augeas.change:
    - context: /files/etc/portage/make.conf
    - changes:
      - set PHP_INI_VERSION '"{{ php_config['ini'] }}"'
    - require:
      - file: augeas-makeconf
{% endif %}

php:
  pkg.installed:
    - pkgs:
{% if grains['os_family'] == 'Gentoo' %}
      - dev-lang/php: ">=5.6.30:{{ php_version }}[fpm,curl,bcmath,embed,gd,inifile,mysql,mysqli,pcntl,pdo,sqlite,snmp,sysvipc,xmlrpc,xmlreader,xmlwriter,xslt]"
      - app-eselect/eselect-php: ">=0.9.2[fpm]"
      - virtual/httpd-php: ">=5.6:{{ php_version }}"
    - watch:
      - augeas: manage-php-ini-version
{% endif %}
