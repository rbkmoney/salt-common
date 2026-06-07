include:
  - gentoo.portage
  - gentoo.eix
  - gentoo.repos.gentoo
  - gentoo.profile
  - gentoo.makeconf
  - .selinux
{% if salt.pillar.get('gentoo:binrepos') or salt.pillar.get('arch_conf:mirror_arch') %}
  - gentoo.binhost-keyring
{% endif %}
