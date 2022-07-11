include:
  - .

extend:
  /etc/bird.conf:
    file.managed:
      - source: salt://bird/files/lbs/bird.conf.tpl
      - template: jinja
