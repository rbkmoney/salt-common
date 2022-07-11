include:
  - .

extend:
  /etc/bird.conf:
    file.managed:
      - source: salt://bird/files/cilium/bird.conf.tpl
      - template: jinja
