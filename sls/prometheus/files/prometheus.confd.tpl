# Managed by Salt
#
# command_args should not be set in this file. Instead, you should set
# prometheus_args.
#
# The default settings are listed below.
# If you are not changing these settings, you do
# not need to include them in prometheus_args.
#
# To migrate from using command_args to prometheus_args, drop any of the
# default settings below that you have set the same way then switch to
# prometheus_args.
#
# The new behavior is that prometheus_args will be appended to these
# defaults.
#
#The default settings are:
#
# --config.file=/etc/prometheus/prometheus.yml
# --storage.tsdb.path=/var/lib/prometheus/data
#
prometheus_args="{{ prometheus_extra_args }}"

# Set memlock, nofile, nproc limits
rc_ulimit="-l {{ l_memlock }} -n {{ l_nofile }} -u {{ l_nproc }}"
