{% set pam_ver = salt['pillar.get']('pam:version', '>=1.2.1-r2') %}
{% set pam_use = salt['pillar.get']('pam:use', ['audit','-berkdb','cracklib','filecaps']) %}


sys-libs/pam:
  pkg.installed:
    - version: "{{ pam_ver }}[{{ ','.join(pam_use) }}]"
