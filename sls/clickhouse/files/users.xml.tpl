{% set config = salt['pillar.get']('clickhouse', {}) %}
<?xml version="1.0"?>
<!--# Managed by Salt -->
<yandex>
  <!-- Profiles of settings. -->
  <profiles>
  	{% set profiles = config.get('profiles', {}) %}
    {% for profile in profiles %}
    <{{ profile }}>
      {% for param, value in profiles[profile].iteritems() %}
      <{{ param }}>{{ value }}</{{ param }}>
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
    {% if value is mapping %}
      <{{ param }}>
      {% for p, v in value.iteritems() %}
      {% if v is iterable %}
        {% for i in v %}
        <{{ p }}>{{ i }}</{{ p }}>
        {%endfor%}
        {% else %}
        <{{ p }}>{{ v }}</{{ p }}>
        {% endif %}
      {% endfor %}
      </{{ param }}>
    {% else %}
      <{{ param }}>{{ value }}</{{ param }}>
    {% endif %}
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
    {% if value is mapping %}
      <{{ param }}>
      {% for p, v in value.iteritems() %}
        <{{ p }}>{{ v }}</{{ p }}>
      {% endfor %}
      </{{ param }}>
    {% else %}
      <{{ param }}>{{ value }}</{{ param }}>
    {% endif %}
    {% endfor %}
    </{{ quota }}>
    {% endfor %}
  </quotas>
</yandex>



