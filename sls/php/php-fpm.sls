# -*- mode: yaml -*-
{% from "php/map.jinja" import php_config with context %}
{% set php_version = php_config['version'] %}
{% set php_short = php_config['short'] %}

include:
  - .{{php_short}}

/etc/php/fpm-php{{ php_version }}/php-fpm.conf:
  file.managed:
    - source: salt://php/files/php-fpm.conf
    - template: jinja
    - context:
        php_version: {{ php_version }}
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
    - source: salt://php/files/fpm.d/default.conf.tpl
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

{% if grains['init'] == 'systemd' %}
/etc/systemd/system/php-fpm.service:
  file.managed:
    - source: salt://php/files/php-fpm.service.tpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - watch_in:
      - service: php-fpm

/etc/init.d/php-fpm: file.absent
/etc/conf.d/php-fpm: file.absent
{% endif %}

php-fpm:
  service.running:
    - enable: True
    - watch:
      - pkg: {{php_short}}
      - eselect: eselect-php-fpm
      - file: /etc/php/fpm-php{{ php_version }}/php-fpm.conf
      - file: /etc/php/fpm-php{{ php_version }}/fpm.d/
