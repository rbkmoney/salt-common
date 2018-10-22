# logrotate(8) configuration file for Gentoo Linux.
# See "man logrotate" for details.
# Managed by Salt

# Rotate log files daily.
{{ salt['pillar.get']('logrotate:default:period', 'daily') }}
# Keep 7 days worth of backlogs.
rotate {{ salt['pillar.get']('logrotate:default:rotate', 7) }}
# Create new (empty) log files after rotating old ones.
create
# Use date as a suffix of the rotated file.
dateext
{% if salt['pillar.get']('logrotate:default:compress', True) %}
# Compress rotated log files.
compress
{% endif %}
{% if salt['pillar.get']('logrotate:default:delaycompress', False) %}
# But not the first rotated one
delaycompress
{% endif %}
# Don't rotate empty logs
notifempty
# Don't mail anything
nomail
# Don't use directories for rotated logs
noolddir
# Packages can drop log rotation information into this directory.
include /etc/logrotate.d

# No packages own wtmp and btmp -- we'll rotate them here.
/var/log/wtmp {
    monthly
    create 0664 root utmp
    minsize 1M
    rotate 1
}
/var/log/btmp {
    missingok
    monthly
    create 0600 root utmp
    rotate 1
}
