{% set config = salt['pillar.get']('clickhouse', {}) %}
<!--# Managed by Salt -->
<?xml version="1.0"?>
<yandex>
  <!-- Profiles of settings. -->
  <profiles>
  	{% set profiles = config.get('profiles', {}) %}
    {% for profile in profiles %}
    <{{ profile }}>
      {% for param, value in profiles[profile].iteritems() %}
      <{{ param }}>{{ value }}<\{{ param }}>
      {% endfor %}
    </{{ profile }}>
    {% endfor %}
  </profiles>

  <!-- Users and ACL. -->
  <users>
    {% set users = config.get('users', {}) %}
    {% for user in users %}
    <{{ user }}>
      {% for param, value in users[user].iteritems() %}
      <{{ param }}>{{ value }}<\{{ param }}>
      {% endfor %}
    </{{ user }}>
    {% endfor %}
  </users>

  <!-- Quotas. -->
  <quotas>
    {% set quotas = config.get('quotas', {}) %}
    {% for quota in quotas %}
    <{{ quota }}>
      {% for param, value in quotas[quota].iteritems() %}
      <{{ param }}>
      	{% for p, v in value.iteritems() %}
      	<{{ p }}>{{ v }}<\{{ p }}>
      	{% endfor %}
      <\{{ param }}>
      {% endfor %}
    </{{ quota }}>
    {% endfor %}
  </quotas>
</yandex>



