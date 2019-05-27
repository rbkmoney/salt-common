{% if packagefile == 'keywords' %}
 {% for atom in packagespillar recursive %}
  {% if packagespillar[atom].kwrd is defined %}
{% if packagespillar[atom].version is defined %}={% endif %}{{ atom }}{% if packagespillar[atom].version is defined %}-{{ packagespillar[atom].version }}{% endif %} {{ packagespillar[atom].kwrd }}
  {% endif %}
 {% endfor %}
{% elif packagefile == 'use' %}
 {% for atom in packagespillar recursive %}
  {% if packagespillar[atom].use is defined %}
{{ atom }} {{ packagespillar[atom].use }}
  {% endif %}
 {% endfor %}
{% endif %}
