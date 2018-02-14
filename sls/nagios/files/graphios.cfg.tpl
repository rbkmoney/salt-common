# Graphios config file
# Basic configuration to send perfdata to local statsd (collectd) instance
[graphios]

#------------------------------------------------------------------------------
# Global Details (you need these!)
#------------------------------------------------------------------------------

# Character to use as replacement for invalid characters in metric names
replacement_character = _

# nagios spool directory
spool_directory = /var/nagios/spool/graphios

# graphios log info
log_file = /var/nagios/graphios.log

# max log size in megabytes (it will rotate the files)
log_max_size = 100

# available log levels:
# DEBUG, INFO, WARNING, ERROR, CRITICAL
# see https://docs.python.org/2/library/logging.html#logging-levels for details
# DEBUG is quite verbose
log_level = logging.INFO

# Disable this once you get it working.
debug = False

# How long to sleep between processing the spool directory
sleep_time = 15

# when we can't connect to carbon, the sleeptime is doubled until we hit max
sleep_max = 480

# test mode makes it so we print what we would add to carbon, and not delete
# any files from the spool directory. log_level must be DEBUG as well.
test_mode = False

# use service description, most people will NOT want this, read documentation!
use_service_desc = False

# replace "." in nagios hostnames? (so "my.host.name" becomes "my_host_name")
# (uses the replacement_character)
replace_hostname = False

# reverse hostname
# if you have:
# host.datacenter.company.tld
# as your nagios hostname you may prefer to have your metric stored as:
# tld.company.datacenter.host
reverse_hostname = True

# This string will be universally pre-pended to metrics, regardless of whether
# or not _graphiteprefix is set. (Quotes not required).
metric_base_path = nagios

enable_statsd = True

# Comma separated list of statsd server IP:Port 's
statsd_servers = 127.0.0.1:8125

#flag the statsd backend as 'non essential' for the purposes of error checking
nerf_statsd = False

#comment the line below to disable the STDOUT sender
enable_stdout = False
nerf_stdout = True
