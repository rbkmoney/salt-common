# -*- mode: shell-script -*-
# Managed by Salt
# you can change the init script behavior by setting those parameters
# - group (default: consul)
# - pidfile (default: /run/consul/consul.pid)
# - user (default: consul)

# extra arguments for the consul agent
data_dir="{{ salt['pillar.get']('consul:data-dir', '/var/lib/consul') }}"
command_args="{{ salt['pillar.get']('consul:command-args', '-config-dir=/etc/consul.d') }}
	-data-dir ${data_dir}"

# upstream strongly recommends > 1
GOMAXPROCS={{ salt['pillar.get']('consul:gomaxproc', 2) }}

user={{ salt['pillar.get']('consul:user', 'consul') }}

{% if salt['pillar.get']('consul:drop-services-on-start', False) %}
start_pre() {
    if [ "$RC_CMD" != restart ]; then
	for dir in services checks; do
	    if [ -d "${data_dir}/${dir}" ]; then
		rm -rf "${data_dir}/${dir}"
	    fi
	done
    fi
}
{% endif %}
