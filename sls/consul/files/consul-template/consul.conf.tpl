# Managed by Salt
{% set conf = salt['pillar.get']('consul:template', {}) %}
{% set conf_consul = conf.get('consul', {}) %}
consul {
  address = "{{ conf_consul.get('address', '[::1]:8500') }}"
  retry {
    backoff = "{{ conf_consul.get('retry-backoff', '10s') }}"
    max_backoff = "{{ conf_consul.get('retry-max-backoff', '5m') }}"
  }
  {% if conf['consul-acl-token'] %}
    token = "{{ conf['consul-acl-token'] }}"
  {% endif %}

}
max_stale = "{{ conf.get('max-stale', '2m') }}"
wait {
  min = "{{ conf.get('wait-min', '5s') }}"
  max = "{{ conf.get('wait-max', '30s') }}"
}
