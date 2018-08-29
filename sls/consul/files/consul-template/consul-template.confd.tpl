# Managed by Salt
# you can change the init script behavior by setting those parameters
# - group (default: consul-template)
# - pidfile (default: /run/consul-template/consul-template.pid)
# - user (default: consul-template)

# extra arguments for the consul agent
user="{{ salt['pillar.get']('consul:template:user', 'root') }}"
group="{{ salt['pillar.get']('consul:template:group', 'root') }}"
command_args="{{ salt['pillar.get']('consul:template:extra-args', '-syslog') }}"
