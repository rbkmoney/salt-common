elastic-oss-repo:
  pkgrepo.managed:
  file.managed:
    - name: /etc/apt/sources.list.d/elastic.list
    - contents: >
        deb [signed-by=/usr/share/keyrings/elastic.gpg]
        https://artifacts.elastic.co/packages/oss-8.x/apt
        stable main
    - require:
      - file: /usr/share/keyrings/elastic.gpg

/usr/share/keyrings/elastic.gpg:
  file.managed:
    - source: salt://elasticsearch/files/release-sign-key
