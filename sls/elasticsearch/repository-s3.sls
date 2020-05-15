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

/etc/elasticsearch/s3_access:
  file.managed:
    - contents_pillar: elastic:config:repository-s3:access_key

/etc/elasticsearch/s3_secret:
  file.managed:
    - contents_pillar: elastic:config:repository-s3:secret_key

update-elasticsearch-keystore:
  cmd.run:
    - env:
      - ES_PATH_CONF: /etc/elasticsearch
    - name: "cat /etc/elasticsearch/s3_access | /usr/share/elasticsearch/bin/elasticsearch-keystore add --stdin --force s3.client.default.access_key && cat /etc/elasticsearch/s3_secret | /usr/share/elasticsearch/bin/elasticsearch-keystore add --stdin --force s3.client.default.secret_key"
    - require:
      - pkg: app-misc/elasticsearch
      - file: /etc/elasticsearch/ 
    - onchanges:
      - file: /etc/elasticsearch/s3_access
      - file: /etc/elasticsearch/s3_secret
