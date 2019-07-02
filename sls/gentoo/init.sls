include:
  - gentoo.portage
  - gentoo.eix
  - gentoo.repos.gentoo
{% if pillar.get('overlay', False) %}
  - gentoo.repos.{{ pillar.get('overlay') }}
{% endif %}
  - gentoo.profile
  - gentoo.makeconf

