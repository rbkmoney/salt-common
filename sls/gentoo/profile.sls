# -*- mode: yaml -*-
{% set arch_conf = salt['pillar.get']('arch_conf', False) %}
eselect-profile:
  eselect.set:
    - name: profile
    {% if arch_conf and arch_conf.get('profile', False) %}
    - target: '{{ arch_conf["profile"] }}'
    {% elif grains['osarch'] == 'x86' %}
    - target: hardened/linux/x86
    {% elif grains['osarch'] == 'x86_64' %}
    - target: hardened/linux/amd64/no-multilib
    {% elif grains['osarch'] == 'armv6l' %}
    - target: hardened/linux/arm/armv6j
    {% endif %}
