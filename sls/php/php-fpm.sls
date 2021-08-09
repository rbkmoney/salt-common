# -*- mode: yaml -*-
{% from "php/map.jinja" import php_config with context %}
{% set php_version = php_config['version'] %}

include:
  - .php74

/etc/php/fpm-php{{ php_version }}/php-fpm.conf:
  file.managed:
    - source: salt://php/php-fpm.conf
    - mode: 644
    - user: root
    - group: root

/etc/php/fpm-php{{ php_version }}/fpm.d/:
  file.directory:
    - create: True
    - mode: 755
    - user: root
    - group: root

/etc/php/fpm-php{{ php_version }}/fpm.d/default.conf:
  file.managed:
    - source: salt://php/fpm.d/default.conf
    - mode: 644
    - user: root
    - group: root
    - require:
      - file: /etc/php/fpm-php{{ php_version }}/fpm.d/

eselect-php-fpm:
  eselect.set:
    - name: php
    - action_parameter: 'fpm'
    - target: 'php{{ php_version }}'

php-fpm:
  service.running:
    - enable: True
    - watch:
      - pkg: php74
      - eselect: eselect-php-fpm
      - file: /etc/php/fpm-php{{ php_version }}/php-fpm.conf
      - file: /etc/php/fpm-php{{ php_version }}/fpm.d/
