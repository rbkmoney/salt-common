{% import 'pkg/common' as pkg %}
include:
  - gentoo.portage.packages
  - gentoo.repos.rbkmoney

app-misc/repository-s3-elasticsearch-plugin:
  pkg.installed:
    - pkgs:
      - {{ pkg.gen_atom('app-misc/repository-s3-elasticsearch-plugin') }}
    - require:
      - file: gentoo.portage.packages
      - git: rbkmoney

update-elasticsearch-keystore:
  cmd.run:
    - env:
      - ES_PATH_CONF: /etc/elasticsearch
    - name: echo {{ s3_config['access_key'] }}| bin/elasticsearch-keystore add --stdin --force s3.client.default.access_key && echo {{ s3_config['secret_key'] }} | bin/elasticsearch-keystore add --stdin --force s3.client.default.secret_key"
    - require:
      - pkg: app-misc/elasticsearch
      - file: /etc/elasticsearch/ 
    - onchanges:
      - file: create-elasticsearch-keystore
