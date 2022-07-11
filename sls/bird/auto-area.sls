include:
  - .

extend:
  /etc/bird.conf:
    file.managed:
      - source: salt://bird/files/auto-area/bird.conf.tpl
      - template: jinja
