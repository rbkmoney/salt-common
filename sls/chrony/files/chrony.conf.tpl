{% set conf = salt['pillar.get']('chrony:conf', {}) -%}
# Managed by Salt

driftfile /var/lib/chrony/drift
{% if grains.init == 'systemd' %}
{% if grains.os == 'Ubuntu' and grains.osmajorrelease == 20 %}
pidfile /run/chronyd.pid
{% else %}
pidfile /run/chrony/chronyd.pid
{% endif %}
{% else %}
pidfile /run/chronyd.pid
{% endif %}
dumpdir /var/lib/chrony
dumponexit

{% for h,c in conf.get('server', {'ntp.bakka.su': 'iburst'}).items() %}
{% if c is not False %}server {{ h }} {{ c }}{% endif %}
{% endfor %}
{% for h,c in conf.get('peer', {}).items() %}
{% if c is not False %}peer {{ h }} {{ c }}{% endif %}
{% endfor %}
{% for h,c in conf.get('pool', {}).items() %}
{% if c is not False %}pool {{ h }} {{ c }}{% endif %}
{% endfor %}

maxupdateskew {{ conf.get('maxupdateskew', 100) }}

# This option is useful to quickly correct the clock on start if it's
# off by a large amount.  The value '10' means that if the error is less
# than 10 seconds, it will be gradually removed by speeding up or
# slowing down your computer's clock until it is correct.  If the error
# is above 10 seconds, an immediate time jump will be applied to correct
# it.  The value '1' means the step is allowed only on the first update
# of the clock.  Some software can get upset if the system clock jumps
# (especially backwards), so be careful!

makestep {{ conf.get('makestep', '30 5') }}
logchange {{ conf.get('logchange', 1) }}

{% if 'log' in conf %}
logdir /var/log/chrony
log {{ conf['log'] }}
{% endif %}

{% for net in conf.get('allow', ['::1']) %}
allow {{ net }}
{% endfor %}
{% for net in conf.get('deny', []) %}
deny {{ net }}
{% endfor %}
clientloglimit {{ conf.get('clientloglimit', 4194304) }}

# Perhaps you want to know if chronyd suddenly detects any large error
# in your computer's clock.  This might indicate a fault or a problem
# with the server(s) you are using, for example.
#
# The next option causes a message to be written to syslog when chronyd
# has to correct an error above 0.5 seconds (you can use any amount you
# like).

bindcmdaddress {{ conf.get('bindcmdaddress', '::1') }}

# Normally, chronyd will only allow connections from chronyc on the same
# machine as itself.  This is for security.  If you have a subnet
# 192.168.*.* and you want to be able to use chronyc from any machine on
# it, you could uncomment the following line.  (Edit this to your own
# situation.)

{% for net in conf.get('cmdallow', ['::1/128']) %}
cmdallow {{ net }}
{% endfor %}
{% for net in conf.get('cmddeny', []) %}
cmddeny {{ net }}
{% endfor %}

rtcfile {{ conf.get('rtcfile', '/var/lib/chrony/rtc') }}
rtconutc
{% if 'rtcdevice' in conf %}rtcdevice {{ conf['rtcdevice'] }}{% endif %}

sched_priority {{ conf.get('sched_priority', 1) }}
lock_all
