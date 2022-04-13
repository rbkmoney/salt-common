elastic-oss-repo:
  pkgrepo.managed:
    - name: >-
        deb https://artifacts.elastic.co/packages/oss-8.x/apt stable main
    - humanname: Elastic OSS
    - file: /etc/apt/sources.list.d/elastic.list
    - gpgkey: salt://elasticsearch/files/release-sign-key
