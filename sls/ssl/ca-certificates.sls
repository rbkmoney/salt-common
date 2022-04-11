{% import 'pkg/common' as pkg %}
ca-certificates:
  pkg.latest:
{% if grains['os'] == 'Gentoo' %}
    - pkgs: [{{ pkg.gen_atom('app-misc/ca-certificates') }}]
{% else %}
    - name: ca-certificates
{% endif %}

/etc/ca-certificates.conf:
  file.managed:
    - replace: false
    - mode: 0644
    - user: root
    - group: root
    - require:
      - pkg: ca-certificates

ca-certificates-dirs:
  file.directory:
    - names:
      - /etc/ssl/certs
      - /etc/ca-certificates
      - /etc/ca-certificates/update.d
    - mode: 0755
    - user: root
    - group: root
    - require:
      - pkg: ca-certificates

/usr/local/share/ca-certificates:
  file.recurse:
    - source: salt://ssl/ca-certificates
    - dir_mode: 755
    - file_mode: 644
    - user: root
    - group: root

/usr/sbin/update-ca-certificates:
  cmd.wait:
    - watch:
      - pkg: ca-certificates
      - file: /etc/ca-certificates.conf
      - file: ca-certificates-dirs
      - file: /usr/local/share/ca-certificates
