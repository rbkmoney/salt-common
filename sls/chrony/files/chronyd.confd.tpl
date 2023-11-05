# Managed by Salt
{# -*- mode: jinja2 -*- #}
CFGFILE="/etc/chrony/chrony.conf"

# Configuration dependent options :
#      -u USER       Specify user (root)
#      -F LEVEL      Set system call filter level (0)
#      -s - Set system time from RTC if rtcfile directive present
#      -r - Reload sample histories if dumponexit directive present
#
# The combination of "-s -r" allows chronyd to perform long term averaging of
# the gain or loss rate across system reboots and shutdowns.
ARGS="{{ salt.pillar.get("chrony:args", "-u ntp -F 2 -s -r") }}"
