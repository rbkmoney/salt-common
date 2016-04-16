# Defaults compiled into the binary
watchdog-device	= /dev/{{ salt['grains.get']('watchdog_device', 'watchdog') }}
admin = root
interval = 1
logtick = 1
log-dir	= /var/log/watchdog

# This greatly decreases the chance that watchdog won't be scheduled before
# your machine is really loaded
realtime = yes
priority = 1
# Check if sshd is still running
# pidfile = /run/sshd.pid

# Uncomment to enable test. Setting one of these values to '0' disables it.
# These values will hopefully never reboot your machine during normal use
# (if your machine is really hung, the loadavg will go much higher than 25)
#max-load-1		= 24
#max-load-5		= 18
max-load-15		= 120 # use auto-generated values from cpu count here?

# Note that this is the number of pages!
# To get the real size, check how large the pagesize is on your machine.
# min-memory = 4
# allocatable-memory = 4
