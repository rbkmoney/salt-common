# Managed by Salt
# -*- mode: jinja2 -*-
# Distributed under the terms of the GNU General Public License v2

# Nice value used to launch collectd, to change priority of the process. As
# you usually will want to run it in background, a default of 5 is used.
#
COLLECTD_NICELEVEL='5'

# Location of configuration file. Modify if you don't like the standard one.
#
COLLECTD_CONFIGFILE='/etc/collectd/collectd.conf'

# File used to store the PID file. Usually you won't need to touch it.
#
COLLECTD_PIDFILE='/run/collectd.pid'

# User to run collectd as (default is collectd, change to root or give
# collectd user appropriate privileges if you use one of the plugins that 
# require it, as e.g. ping or iptables plugins)
#
COLLECTD_USER='{{ salt.pillar.get('collectd:service:user', 'root') }}'
