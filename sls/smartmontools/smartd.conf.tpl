# Managed by Salt
{% set default_email = salt['pillar.get']('contacts:default:email', False)  %}
# HERE IS A LIST OF DIRECTIVES FOR THIS CONFIGURATION FILE.
# PLEASE SEE THE smartd.conf MAN PAGE FOR DETAILS
#
#   -d TYPE Set the device type: ata, scsi, marvell, removable, 3ware,N, hpt,L/M/N
#   -T TYPE set the tolerance to one of: normal, permissive
#   -o VAL  Enable/disable automatic offline tests (on/off)
#   -S VAL  Enable/disable attribute autosave (on/off)
#   -n MODE No check. MODE is one of: never, sleep, standby, idle
#   -H      Monitor SMART Health Status, report if failed
#   -l TYPE Monitor SMART log.  Type is one of: error, selftest
#   -f      Monitor for failure of any 'Usage' Attributes
#   -m ADD  Send warning email to ADD for -H, -l error, -l selftest, and -f
#   -M TYPE Modify email warning behavior (see man page)
#   -s REGE Start self-test when type/date matches regular expression (see man page)
#   -p      Report changes in 'Prefailure' Normalized Attributes
#   -u      Report changes in 'Usage' Normalized Attributes
#   -t      Equivalent to -p and -u Directives
#   -r ID   Also report Raw values of Attribute ID with -p, -u or -t
#   -R ID   Track changes in Attribute ID Raw value with -p, -u or -t
#   -i ID   Ignore Attribute ID for -f Directive
#   -I ID   Ignore Attribute ID for -p, -u or -t Directive
#   -C ID   Report if Current Pending Sector count non-zero
#   -U ID   Report if Offline Uncorrectable count non-zero
#   -W D,I,C Monitor Temperature D)ifference, I)nformal limit, C)ritical limit
#   -v N,ST Modifies labeling of Attribute N (see man page)
#   -a      Default: equivalent to -H -f -t -l error -l selftest -C 197 -U 198
#   -F TYPE Use firmware bug workaround. Type is one of: none, samsung
#   -P TYPE Drive-specific presets: use, ignore, show, showall
#    #      Comment: text after a hash sign is ignored
#    \      Line continuation character
# Attribute ID is a decimal integer 1 <= ID <= 255
# except for -C and -U, where ID = 0 turns them off.
# All but -d, -m and -M Directives are only implemented for ATA devices
#
# If the test string DEVICESCAN is the first uncommented text
# then smartd will scan for devices.
# DEVICESCAN may be followed by any desired Directives.
DEVICESCAN -s S/../../1/10 {% if default_email %}-m {{ default_email }}{% endif %}
