{% if grains['init'] == 'systemd' and grains['elibc'] == 'musl' %}
/etc/portage/make.profile/parent:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - contents: |
        gentoo:default/linux/amd64/23.0/musl/hardened/selinux
        gentoo:targets/systemd
{% else %}
{% set arch_conf = salt.pillar.get('arch_conf', False) %}
{% if arch_conf and arch_conf.get('profile', False) %}
eselect-profile:
  eselect.set:
    - name: profile
    - target: '{{ arch_conf["profile"] }}'
{% endif %}
{% endif %}
