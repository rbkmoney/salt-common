# /etc/conf.d/xendomains

# Directory of domains to boot. AUTODIR should contain one or more symlinks
# to domain config files in /etc/xen
AUTODIR=/etc/xen/auto

# Send shutdown commands to all domains in parallel instead of waiting for
# each to shutdown individually
PARALLEL_SHUTDOWN=yes

# When SCREEN="yes", domains in AUTODIR have their consoles connected to a
# screen session named SCREEN_NAME, with output logged to individual files 
# named after each domain and written to /var/log/xen-consoles/ . These files
# are rotated (using app-admin/logrotate) every time xendomains is started.

SCREEN="{{ pillar.get("confd:xendomains:screen", 'yes') }}"
SCREEN_NAME="xen"

# Number of seconds between writes to screen's logfiles.
#
# Lower values mean more disk activity and hence a possible performance
# impact, but higher values mean a greater chance of losing some output
# in the event of a crash.

SCREEN_LOG_INTERVAL="1"

rc_xendomains_need="{{ pillar.get("confd:rc:xendomains:need", '') }}"
rc_xendomains_use="{{ pillar.get("confd:rc:xendomains:need", '') }}"
