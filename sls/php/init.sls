# -*- mode: yaml -*-
{% from "php/map.jinja" import php_config with context %}
{% set php_version = php_config['version'] %}

include:
  - ssl.openssl
{% if grains['os_family'] == 'Gentoo' %}
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
      - dev-lang/php: ">=5.6.17:{{ php_version }}[fpm,curl,bcmath,embed,gd,inifile,mysql,mysqli,pcntl,pdo,snmp,sysvipc,xmlrpc,xmlreader,xmlwriter,xslt]"
      - app-eselect/eselect-php: ">=0.7.1-r4[fpm]"
      - virtual/httpd-php: ">=5.6:{{ php_version }}"
      - app-emacs/php-mode
    - watch:
      - augeas: manage-php-ini-version
{% endif %}
