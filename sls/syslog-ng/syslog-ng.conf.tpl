@version: 3.25

@include "scl.conf"
@include "conf.d"

{% set syslog_local = salt['pillar.get']('syslog:local', True) %}
{% set syslog_server = salt['pillar.get']('syslog:server', {}) %}
{% set syslog_client = salt['pillar.get']('syslog:client', {}) %}

options { 
        threaded(yes);
        chain_hostnames(no); 
        group("log");
        perm(0640);
        dir_perm(0750);
        create_dirs(yes);
        # The default action of syslog-ng is to log a STATS line
        # to the file every 10 minutes.  That's pretty ugly after a while.
        # Change it to every 12 hours so you get a nice daily update of
        # how many messages syslog-ng missed (0).
        stats_freq(43200); 
        # The default action of syslog-ng is to log a MARK line
        # to the file every 20 minutes.  That's seems high for most
        # people so turn it down to once an hour.  Set it to zero
        # if you don't want the functionality at all.
        mark_freq(3600); 
};

source syslog {
   internal();
   unix-stream("/dev/log" max-connections(256));
};
source kernel {
   file("/proc/kmsg");
};

destination auth { file("/var/log/auth.log"); };
destination syslog { file("/var/log/syslog"); };
destination cron { file("/var/log/cron.log"); };
destination mail { file("/var/log/mail.log"); };
destination daemon { file("/var/log/daemon.log"); };
destination user { file("/var/log/user.log"); };

destination iptables { file("/var/log/iptables.log"); };
destination kernel { file("/var/log/kernel.log"); };
destination error { file("/var/log/error.log"); };
destination messages { file("/var/log/messages"); };

destination filebeat_json {
  file("/var/log/messages.json"
    template("$(format-json --scope selected_macros,nv_pairs --exclude DATE --exclude LEGACY_* --exclude SEQNUM --pair @timestamp=\"${ISODATE}\" --pair @version=int(1))\n"));
};

destination tty12 { file("/dev/tty12"); };
destination console { file("/dev/console"); };

{% if syslog_client %}
destination remote_syslog {
  network("{{ syslog_client['addr'] }}" ip-protocol({{ syslog_client.get('proto', 6) }}) transport(udp));
};

log { source(kernel); destination(remote_syslog); };
log { source(syslog); destination(remote_syslog); };
{% endif %}
{% if syslog_local %}
filter f_authpriv { facility(auth, authpriv); };
filter f_syslog { facility(syslog); };
filter f_cron { facility(cron); };
filter f_mail { facility(mail); };
filter f_daemon { facility(daemon); };
filter f_user { facility(user); };

filter f_error { priority(error); };

filter f_iptables { message("^(\\[.*\..*\] |)iptables:.*"); };

log { source(kernel); filter(f_iptables); destination(iptables); };
log { source(kernel); destination(kernel); };
log { source(kernel); filter(f_error); destination(error); };

log { source(syslog); filter(f_authpriv); destination(auth); };
log { source(syslog); filter(f_syslog); destination(syslog); };
log { source(syslog); filter(f_cron); destination(cron); };
log { source(syslog); filter(f_mail); destination(mail); };
log { source(syslog); filter(f_daemon); destination(daemon); };
log { source(syslog); filter(f_user); destination(user); };

log { source(syslog); destination(messages); };

log { source(kernel); destination(filebeat_json); };
log { source(syslog); destination(filebeat_json); };
{% endif %}
{% if syslog_server %}
source remote_syslog {
   syslog({% for k, v in syslog_server.get('opts',
	     {'transport': 'udp',
	      'ip-protocol': 6,
	      'keep-hostname': 'yes'}).items() %}
     {{ k }}({{ v }})
     {% endfor %});
};
{% if syslog_local %}
destination remote_by_facility {
   file("/var/log/remote/$HOST/$FACILITY.log");
};

log { source(remote_syslog); destination(remote_by_facility); };
log { source(remote_syslog); destination(filebeat_json); };
{% endif %}
{% endif %}
