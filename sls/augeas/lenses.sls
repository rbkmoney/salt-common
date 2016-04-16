include:
  - augeas

{% set default_lenses = ['makeconf', 'confd'] %}
{% set extra_lenses = salt['pillar.get']('augeas_extra_lenses', []) %}

{% for lensname in default_lenses + extra_lenses %}
augeas-{{ lensname }}:
  file.managed:
    - name: /usr/share/augeas/lenses/{{ lensname }}.aug
    - source: salt://augeas/lenses/{{ lensname }}.aug
{% endfor %}
