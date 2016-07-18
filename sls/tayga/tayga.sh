# Copyright (c) 2016 Victory Ejevika <ki@bakka.su>
# Released under the 2-clause BSD license.
# Based on TUN/TAP module by Roy Marples <roy@marples.name>

tayga_depend()
{
    before bridge interface macchanger
    program tayga
}

_config_vars="$_config_vars"

_is_tayga()
{
    [ -n "$(RC_SVCNAME="net.${IFACE}"; export RC_SVCNAME ; service_get_value tayga)" ]
}

tayga_pre_start()
{
    local rc=

    if [ ! -e /dev/net/tun ]; then
	if ! modprobe tun; then
	    eerror "TUN/TAP support is not present in this kernel"
	    return 1
	fi
	vebegin "Waiting for /dev/net/tun"
	# /dev/net/tun can take its time to appear
	local timeout=10
	while [ ! -e /dev/net/tun -a ${timeout} -gt 0 ]; do
	    sleep 1
	    : $(( timeout -= 1 ))
	done
	if [ ! -e /dev/net/tun ]; then
	    eerror "TUN/TAP support present but /dev/net/tun is not"
	    return 1
	fi
	veend 0
    fi

    ebegin "Creating nat64 interface ${IFACE}"

    local t_opts=
    eval t_opts=\$tayga_opts_${IFVAR}

    if type tayga >/dev/null 2>&1; then
	tayga --mktun  ${t_opts} #add dev "${IFACE}"
	rc=$?
    else
	eerror "TAYGA is not found, please install it, or add to your PATH"
	rc=1
    fi
    eend $rc && _up && service_set_value tayga "${tayga}"
}

tayga_post_stop()
{
    _is_tayga || return 0

    ebegin "Destroying nat64 interface ${IFACE}"
    if type tayga > /dev/null 2>&1; then
	tayga --rmtun
    else
	eerror "TAYGA is not found, please install it, or add to your PATH"
	rc=1
    fi
    eend $?
}
