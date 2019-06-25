# TODO: remove from deps
{% set pam_ver = salt['pillar.get']('pam:version', '>=1.3.0-r2') %}
{% set pam_use = salt['pillar.get']('pam:use', ['-audit','-berkdb','cracklib','filecaps']) %}
{% set pambase_use = salt['pillar.get']('pam:pambase:use', ['cracklib','nullok','sha512']) %}
{% set libs_packaged = salt['pillar.get']('libs:packaged', False) %}

sys-libs/pam:
  pkg.installed:
    - version: "{{ pam_ver }}[{{ ','.join(pam_use) }}]"
    {% if libs_packaged %}
    - binhost: force
    {% endif %}

sys-auth/pambase:
  pkg.latest:
    - version: "[{{ ','.join(pambase_use) }}]"
    {% if libs_packaged %}
    - binhost: force
    {% endif %}
    - require:
      - pkg: sys-libs/pam

virtual/pam:
  pkg.latest:
    - require:
      - pkg: sys-libs/pam
