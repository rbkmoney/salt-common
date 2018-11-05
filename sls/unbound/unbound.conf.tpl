# -*- mode: yaml -*-
# Managed by Salt
#include: "otherfile.conf"
# The server clause sets the main parameters. 
server:
    # Detach from the terminal, run in background, "yes" or "no".
    do-daemonize: yes

    # verbosity number, 0 is least verbose. 1 is default.
    verbosity: {{ salt['pillar.get']('unbound:verbosity', 1) }}

    # print statistics to the log (for every thread) every N seconds.
    # Set to "" or 0 to disable. Default is disabled.
    statistics-interval: {{ salt['pillar.get']('unbound:statistics-interval', 3600) }}

    # enable cumulative statistics, without clearing them after printing.
    statistics-cumulative: {{ 'yes' if salt['pillar.get']('unbound:statistics-cumulative', False) else 'no' }}

    # enable extended statistics (query types, answer codes, status)
    # printed from unbound-control. default off, because of speed.
    extended-statistics: {{ 'yes' if salt['pillar.get']('unbound:extended-statistics', False) else 'no' }}

    # number of threads to create. 1 disables threading.
    num-threads: {{ salt['pillar.get']('unbound:num-threads', salt['grains.get']('num_cpus', 2)) }}

    # specify the interfaces to answer queries from by ip-address.
    # The default is to listen to localhost (127.0.0.1 and ::1).
    # specify 0.0.0.0 and ::0 to bind to all available interfaces.
    # specify every interface[@port] on a new 'interface:' labelled line.
    # The listen interfaces are not changed on reload, only on restart.
    {% if salt['pillar.get']('unbound:interfaces', False) %}
    {% for address in salt['pillar.get']('unbound:interfaces') %}
    interface: {{ address }}
    {% endfor %}
    {% else %}
    interface: ::1
    interface: ::0
    interface: 0.0.0.0
    {% endif %}
    # enable this feature to copy the source address of queries to reply.
    # Socket options are not supported on all platforms. experimental. 
    interface-automatic: {{ 'yes' if salt['pillar.get']('unbound:interface-automatic', True) else 'no' }}

    # port to answer queries from
    port: {{ salt['pillar.get']('unbound:port', 53) }}

    # specify the interfaces to send outgoing queries to authoritative
    # server from by ip-address. If none, the default (all) interface
    # is used. Specify every interface on a 'outgoing-interface:' line.
    {% if salt['pillar.get']('unbound:outgoing-interfaces', False) %}
    {% for address in salt['pillar.get']('unbound:outgoing-interfaces') %}
    outgoing-interface: {{ address }}
    {% endfor %}
    {% endif %}


    # the number of queries that a thread gets to service.
    num-queries-per-thread: {{ salt['pillar.get']('unbound:num-queries-per-thread', 2048) }}

    # number of ports to allocate per thread, determines the size of the
    # port range that can be open simultaneously.  About double the
    # num-queries-per-thread, or, use as many as the OS will allow you.
    outgoing-range: {{ salt['pillar.get']('unbound:outgoing-range', 4096) }}

    # permit unbound to use this port number or port range for
    # making outgoing queries, using an outgoing interface.
    # outgoing-port-permit: 32768

    # deny unbound the use this of port number or port range for
    # making outgoing queries, using an outgoing interface.
    # Use this to make sure unbound does not grab a UDP port that some
    # other server on this computer needs. The default is to avoid
    # IANA-assigned port numbers.
    # If multiple outgoing-port-permit and outgoing-port-avoid options
    # are present, they are processed in order.
    # outgoing-port-avoid: "3200-3208"

    # number of outgoing simultaneous tcp buffers to hold per thread.
    outgoing-num-tcp: {{ salt['pillar.get']('unbound:outgoing-num-tcp', 10) }}

    # number of incoming simultaneous tcp buffers to hold per thread.
    incoming-num-tcp: {{ salt['pillar.get']('unbound:incoming-num-tcp', 10) }}

    # buffer size for UDP port 53 incoming (SO_RCVBUF socket option).
    # 0 is system default.  Use 4m to catch query spikes for busy servers.
    so-rcvbuf: {{ salt['pillar.get']('unbound:so-rcvbuf', 0) }}

    # buffer size for UDP port 53 outgoing (SO_SNDBUF socket option).
    # 0 is system default.  Use 4m to handle spikes on very busy servers.
    so-sndbuf: {{ salt['pillar.get']('unbound:so-sndbuf', 0) }}
    
    # use SO_REUSEPORT to distribute queries over threads.
    so-reuseport: {{ 'yes' if salt['pillar.get']('unbound:so-reuseport', True) else 'no' }}

    # EDNS reassembly buffer to advertise to UDP peers (the actual buffer
    # is set with msg-buffer-size). 1480 can solve fragmentation (timeouts).
    edns-buffer-size: {{ salt['pillar.get']('unbound:edns-buffer-size', 8192) }}

    # Maximum UDP response size (not applied to TCP response).
    # Suggested values are 512 to 4096. Default is 4096. 65536 disables it.
    max-udp-size: {{ salt['pillar.get']('unbound:max-udp-size', 4096) }}

    # buffer size for handling DNS data. No messages larger than this
    # size can be sent or received, by UDP or TCP. In bytes.
    msg-buffer-size: {{ salt['pillar.get']('unbound:msg-buffer-size', 65552) }}

    # the amount of memory to use for the message cache.
    # plain value in bytes or you can append k, m or G. default is "4Mb". 
    msg-cache-size: {{ salt['pillar.get']('unbound:msg-cache-size', '4m') }}

    # the number of slabs to use for the message cache.
    # the number of slabs must be a power of 2.
    # more slabs reduce lock contention, but fragment memory usage.
    msg-cache-slabs: {{ salt['pillar.get']('unbound:msg-cache-slabs', 4) }}

    # if very busy, 50% queries run to completion, 50% get timeout in msec
    jostle-timeout: {{ salt['pillar.get']('unbound:jostle-timeout', 200) }}
    
    # msec to wait before close of port on timeout UDP. 0 disables.
    delay-close: {{ salt['pillar.get']('unbound:delay-close', 0) }}

    # the amount of memory to use for the RRset cache.
    # plain value in bytes or you can append k, m or G. default is "4Mb". 
    rrset-cache-size: {{ salt['pillar.get']('unbound:rrset-cache-size', '4m') }}

    # the number of slabs to use for the RRset cache.
    # the number of slabs must be a power of 2.
    # more slabs reduce lock contention, but fragment memory usage.
    rrset-cache-slabs: {{ salt['pillar.get']('unbound:rrset-cache-slabs', 4) }}

    # the time to live (TTL) value lower bound, in seconds. Default 0.
    # If more than an hour could easily give trouble due to stale data.
    cache-min-ttl: {{ salt['pillar.get']('unbound:cache-min-ttl', 0) }}

    # the time to live (TTL) value cap for RRsets and messages in the
    # cache. Items are not cached for longer. In seconds.
    cache-max-ttl: {{ salt['pillar.get']('unbound:cache-max-ttl', 86400) }}

    # the time to live (TTL) value for cached roundtrip times, lameness and
    # EDNS version information for hosts. In seconds.
    infra-host-ttl: {{ salt['pillar.get']('unbound:infra-host-ttl', 900) }}

    # the number of slabs to use for the Infrastructure cache.
    # the number of slabs must be a power of 2.
    # more slabs reduce lock contention, but fragment memory usage.
    infra-cache-slabs: {{ salt['pillar.get']('unbound:infra-cache-slabs', 4) }}

    do-ip4: yes
    do-ip6: yes
    do-udp: yes
    do-tcp: yes

    # upstream connections use TCP only (and no UDP), "yes" or "no"
    # useful for tunneling scenarios, default no.
    tcp-upstream: {{ 'yes' if salt['pillar.get']('unbound:tcp-upstream', False) else 'no' }}
    
    # control which clients are allowed to make (recursive) queries
    # to this server. Specify classless netblocks with /size and action.
    # By default everything is refused, except for localhost.
    # Choose deny (drop message), refuse (polite error reply),
    # allow (recursive ok), allow_snoop (recursive and nonrecursive ok)
    # deny_non_local (drop queries unless can be answered from local-data)
    # refuse_non_local (like deny_non_local but polite error reply).
    # access-control: 0.0.0.0/0 refuse
    {% if salt['pillar.get']('unbound:access-control', False) %}
    {% for ac in salt['pillar.get']('unbound:access-control') %}
    access-control: {{ ac['netblock'] }} {{ ac['rule'] }}
    {% endfor %}
    {% else %}
    access-control: ::1 allow
    {% endif %}

    # if given, a chroot(2) is done to the given directory.
    # i.e. you can chroot to the working directory, for example,
    # for extra security, but make sure all files are in that directory.
    #
    # If chroot is enabled, you should pass the configfile (from the
    # commandline) as a full path from the original root. After the
    # chroot has been performed the now defunct portion of the config 
    # file path is removed to be able to reread the config after a reload. 
    #
    # All other file paths (working dir, logfile, roothints, and
    # key files) can be specified in several ways:
    #     o as an absolute path relative to the new root.
    #     o as a relative path to the working directory.
    #     o as an absolute path relative to the original root.
    # In the last case the path is adjusted to remove the unused portion.
    #
    # The pid file can be absolute and outside of the chroot, it is 
    # written just prior to performing the chroot and dropping permissions.
    #
    # Additionally, unbound may need to access /dev/random (for entropy).
    # How to do this is specific to your OS.
    #
    # If you give "" no chroot is performed. The path must not end in a /.
    chroot: ""

    # if given, user privileges are dropped (after binding port),
    # and the given username is assumed. Default is user "unbound".
    # If you give "" no privileges are dropped.
    username: "unbound"

    # the working directory. The relative files in this config are 
    # relative to this directory. If you give "" the working directory
    # is not changed.
    directory: "/etc/unbound"

    # the pid file. Can be an absolute path outside of chroot/work dir.
    pidfile: "/run/unbound.pid"

    {% if salt['pillar.get']('unbound:logfile', False) %}
    # the log file, "" means log to stderr. 
    # Use of this option sets use-syslog to "no".
    logfile: "{{ salt['pillar.get']('unbound:logfile') }}"
    {% else %}
    # Log to syslog(3) if yes. The log facility LOG_DAEMON is used to 
    # log to, with identity "unbound". If yes, it overrides the logfile.
    use-syslog: 'yes'
    {% endif %}

    # print UTC timestamp in ascii to logfile, default is epoch in seconds.
    log-time-ascii: {{ 'yes' if salt['pillar.get']('unbound:log-time-ascii', True) else 'no' }}
    
    # print one line with time, IP, name, type, class for every query.
    log-queries: {{ 'yes' if salt['pillar.get']('unbound:log-queries', False) else 'no' }}

    # file to read root hints from.
    # get one from ftp://FTP.INTERNIC.NET/domain/named.cache
    # root-hints: ""

    # enable to not answer id.server and hostname.bind queries.
    hide-identity: {{ 'yes' if salt['pillar.get']('unbound:hide-identity', False) else 'no' }}

    # enable to not answer version.server and version.bind queries.
    hide-version: {{ 'yes' if salt['pillar.get']('unbound:hide-version', False) else 'no' }}

    # the identity to report. Leave "" or default to return hostname.
    identity: "{{ salt['pillar.get']('unbound:identity', 'Recursive unbound DNS') }}"

    # the version to report. Leave "" or default to return package version.
    # version: ""

    # the target fetch policy.
    # series of integers describing the policy per dependency depth. 
    # The number of values in the list determines the maximum dependency 
    # depth the recursor will pursue before giving up. Each integer means:
    #     -1 : fetch all targets opportunistically,
    #     0: fetch on demand,
    #    positive value: fetch that many targets opportunistically.
    # Enclose the list of numbers between quotes ("").
    target-fetch-policy: "{{ salt['pillar.get']('target-fetch-policy', '3 2 1 0 0 0') }}"

    # Harden against very small EDNS buffer sizes. 
    harden-short-bufsize: {{ 'yes' if salt['pillar.get']('unbound:harden-short-bufsize', True) else 'no' }}

    # Harden against unseemly large queries.
    harden-large-queries: {{ 'yes' if salt['pillar.get']('unbound:harden-large-queries', True) else 'no' }}

    # Harden against out of zone rrsets, to avoid spoofing attempts. 
    harden-glue: {{ 'yes' if salt['pillar.get']('unbound:harden-glue', True) else 'no' }}

    # Harden against receiving dnssec-stripped data. If you turn it
    # off, failing to validate dnskey data for a trustanchor will 
    # trigger insecure mode for that zone (like without a trustanchor).
    # Default on, which insists on dnssec data for trust-anchored zones.
    harden-dnssec-stripped: {{ 'yes' if salt['pillar.get']('unbound:harden-dnssec-stripped', True) else 'no' }}

    # Harden against queries that fall under dnssec-signed nxdomain names.
    harden-below-nxdomain: {{ 'yes' if salt['pillar.get']('unbound:harden-below-nxdomain', True) else 'no' }}

    # Harden the referral path by performing additional queries for
    # infrastructure data.  Validates the replies (if possible).
    # Default off, because the lookups burden the server.  Experimental 
    # implementation of draft-wijngaards-dnsext-resolver-side-mitigation.
    harden-referral-path: {{ 'yes' if salt['pillar.get']('unbound:harden-referral-path', False) else 'no' }}

    # Use 0x20-encoded random bits in the query to foil spoof attempts.
    # This feature is an experimental implementation of draft dns-0x20.
    use-caps-for-id: {{ 'yes' if salt['pillar.get']('unbound:use-caps-for-id', False) else 'no' }}

    # Enforce privacy of these addresses. Strips them away from answers. 
    # It may cause DNSSEC validation to additionally mark it as bogus. 
    # Protects against 'DNS Rebinding' (uses browser as network proxy). 
    # Only 'private-domain' and 'local-data' names are allowed to have 
    # these private addresses. No default.
    # private-address: 10.0.0.0/8
    # private-address: 172.16.0.0/12
    # private-address: 192.168.0.0/16
    # private-address: 169.254.0.0/16
    # private-address: fd00::/8
    # private-address: fe80::/10

    # Allow the domain (and its subdomains) to contain private addresses.
    # local-data statements are allowed to contain private addresses too.
    # private-domain: "example.com"

    # If nonzero, unwanted replies are not only reported in statistics,
    # but also a running total is kept per thread. If it reaches the
    # threshold, a warning is printed and a defensive action is taken,
    # the cache is cleared to flush potential poison out of it.
    # A suggested value is 10000000, the default is 0 (turned off).
    unwanted-reply-threshold: {{ salt['pillar.get']('unbound:unwanted-reply-threshold', 0) }}

    # Do not query the following addresses. No DNS queries are sent there.
    # List one address per entry. List classless netblocks with /size,
    # do-not-query-address: 127.0.0.1/8
    # do-not-query-address: ::1

    # if yes, the above default do-not-query-address entries are present.
    # if no, localhost can be queried (for testing and debugging).
    do-not-query-localhost: {{ 'yes' if salt['pillar.get']('unbound:do-not-query-localhost', True) else 'no' }}

    # if yes, perform prefetching of almost expired message cache entries.
    prefetch: {{ 'yes' if salt['pillar.get']('unbound:prefetch', True) else 'no' }}

    # if yes, perform key lookups adjacent to normal lookups.
    prefetch-key: {{ 'yes' if salt['pillar.get']('unbound:prefetch-key', True) else 'no' }}

    # if yes, Unbound rotates RRSet order in response.
    rrset-roundrobin: {{ 'yes' if salt['pillar.get']('unbound:rrset-roundrobin', True) else 'no' }}

    # if yes, Unbound doesn't insert authority/additional sections
    # into response messages when those sections are not required.
    minimal-responses: {{ 'yes' if salt['pillar.get']('unbound:minimal-responses', True) else 'no' }}

    # module configuration of the server. A string with identifiers
    # separated by spaces. Syntax: "[dns64] [validator] iterator"
    module-config: "{{ salt['pillar.get']('unbound:module-config', 'validator iterator') }}"

    # File with trusted keys, kept uptodate using RFC5011 probes,
    # initial file like trust-anchor-file, then it stores metadata.
    # Use several entries, one per domain name, to track multiple zones.
    #
    # If you want to perform DNSSEC validation, run unbound-anchor before
    # you start unbound (i.e. in the system boot scripts).  And enable:
    # Please note usage of unbound-anchor root anchor is at your own risk
    # and under the terms of our LICENSE (see that file in the source).
    auto-trust-anchor-file: "/etc/dnssec/root-anchors.txt"

    # File with DLV trusted keys. Same format as trust-anchor-file.
    # There can be only one DLV configured, it is trusted from root down.
    # Download http://ftp.isc.org/www/dlv/dlv.isc.org.key
    # dlv-anchor-file: "dlv.isc.org.key"

    # File with trusted keys for validation. Specify more than one file
    # with several entries, one file per entry.
    # Zone file format, with DS and DNSKEY entries.
    # Note this gets out of date, use auto-trust-anchor-file please.
    # trust-anchor-file: "/etc/dnssec/root-anchors.txt"

    # File with trusted keys for validation. Specify more than one file
    # with several entries, one file per entry. Like trust-anchor-file
    # but has a different file format. Format is BIND-9 style format, 
    # the trusted-keys { name flag proto algo "key"; }; clauses are read.
    # you need external update procedures to track changes in keys.
    # trusted-keys-file: ""

    {% if salt['pillar.get']('unbound:domain-insecure', False) %}
    # Ignore chain of trust. Domain is treated as insecure.
    {% for domain in salt['pillar.get']('unbound:domain-insecure') %}
    domain-insecure: "{{ domain }}"
    {% endfor %}
    {% endif %}

    # The time to live for bogus data, rrsets and messages. This avoids
    # some of the revalidation, until the time interval expires. in secs.
    val-bogus-ttl: {{ salt['pillar.get']('unbound:val-bogus-ttl', 300) }}

    # The signature inception and expiration dates are allowed to be off
    # by 10% of the signature lifetime (expir-incep) from our local clock.
    # This leeway is capped with a minimum and a maximum.  In seconds.
    val-sig-skew-min: 3600
    val-sig-skew-max: 86400

    # Should additional section of secure message also be kept clean of
    # unsecure data. Useful to shield the users of this validator from
    # potential bogus data in the additional section. All unsigned data 
    # in the additional section is removed from secure messages.
    val-clean-additional: {{ 'yes' if salt['pillar.get']('unbound:val-clean-additional', True) else 'no' }}

    # Turn permissive mode on to permit bogus messages. Thus, messages
    # for which security checks failed will be returned to clients,
    # instead of SERVFAIL. It still performs the security checks, which
    # result in interesting log files and possibly the AD bit in
    # replies if the message is found secure. The default is off.
    val-permissive-mode: {{ 'yes' if salt['pillar.get']('unbound:val-permissive-mode', False) else 'no' }}

    # Ignore the CD flag in incoming queries and refuse them bogus data.
    # Enable it if the only clients of unbound are legacy servers (w2008)
    # that set CD but cannot validate themselves.
    ignore-cd-flag: {{ 'yes' if salt['pillar.get']('unbound:ignore-cd-flag', False) else 'no' }}

    # Have the validator log failed validations for your diagnosis.
    # 0: off. 1: A line per failed user query. 2: With reason and bad IP.
    val-log-level: {{ salt['pillar.get']('unbound:val-log-level', 1) }}

    # It is possible to configure NSEC3 maximum iteration counts per
    # keysize. Keep this table very short, as linear search is done.
    # A message with an NSEC3 with larger count is marked insecure.
    # List in ascending order the keysize and count values.
    val-nsec3-keysize-iterations: "{{ salt['pillar.get']('unbound:val-nsec3-keysize-iterations', '1024 150 2048 500 4096 2500') }}"
    
    # instruct the auto-trust-anchor-file probing to add anchors after ttl.
    add-holddown: {{ salt['pillar.get']('unbound:add-holddown', 2592000) }} # 30 days

    # instruct the auto-trust-anchor-file probing to del anchors after ttl.
    del-holddown: {{ salt['pillar.get']('unbound:del-holddown', 2592000) }} # 30 days

    # auto-trust-anchor-file probing removes missing anchors after ttl.
    # If the value 0 is given, missing anchors are not removed.
    keep-missing: {{ salt['pillar.get']('unbound:keep-missing', 31622400) }} # 366 days

    # the amount of memory to use for the key cache.
    # plain value in bytes or you can append k, m or G. default is "4Mb". 
    key-cache-size: {{ salt['pillar.get']('unbound:key-cache-size', '4m') }}

    # the number of slabs to use for the key cache.
    # the number of slabs must be a power of 2.
    # more slabs reduce lock contention, but fragment memory usage.
    key-cache-slabs: {{ salt['pillar.get']('unbound:key-cache-slabs', 4) }}

    # the amount of memory to use for the negative cache (used for DLV).
    # plain value in bytes or you can append k, m or G. default is "1Mb". 
    neg-cache-size: {{ salt['pillar.get']('unbound:neg-cache-size', '1m') }}
    
    # if unbound is running service for the local host then it is useful
    # to perform lan-wide lookups to the upstream, and unblock the
    # long list of local-zones above.  If this unbound is a dns server
    # for a network of computers, disabled is better and stops information
    # leakage of local lan information.
    unblock-lan-zones: {{ 'yes' if salt['pillar.get']('unbound:unblock-lan-zones', False) else 'no' }}

    {% if salt['pillar.get']('unbound:local-zone', False) %}
    # a number of locally served zones can be configured.
    #     local-zone: <zone> <type>
    #     local-data: "<resource record string>"
    # o deny serves local data (if any), else, drops queries. 
    # o refuse serves local data (if any), else, replies with error.
    # o static serves local data, else, nxdomain or nodata answer.
    # o transparent gives local data, but resolves normally for other names
    # o redirect serves the zone data for any subdomain in the zone.
    # o nodefault can be used to normally resolve AS112 zones.
    # o typetransparent resolves normally for other types and other names
    #
    # defaults are localhost address, reverse for 127.0.0.1 and ::1
    # and nxdomain for AS112 zones. If you configure one of these zones
    # the default content is omitted, or you can omit it with 'nodefault'.
    # 
    # If you configure local-data without specifying local-zone, by
    # default a transparent local-zone is created for the data.
    #
    # You can add locally served data with
    # local-zone: "local." static
    {% for lz in salt['pillar.get']('unbound:local-zone') %}
    local-zone: "{{ lz['zone'] }}" {{ lz['rule'] }}
    {% endfor %}
    {% endif %}
    {% if salt['pillar.get']('unbound:local-data', False) %}
    {% for ld in salt['pillar.get']('unbound:local-data') %}
    local-data: "{{ ld }}"
    {% endfor %}
    {% endif %}
    {% if salt['pillar.get']('unbound:local-data-ptr', False) %}
    # Shorthand to make PTR records, "IPv4 name" or "IPv6 name".
    # You can also add PTR records using local-data directly, but then
    # you need to do the reverse notation yourself.
    {% for ldp in salt['pillar.get']('unbound:local-data-ptr') %}
    local-data-ptr: "{{ ldp }}"
    {% endfor %}
    {% endif %}
    # service clients over SSL (on the TCP sockets), with plain DNS inside
    # the SSL stream.  Give the certificate to use and private key.
    # default is "" (disabled).  requires restart to take effect.
    # ssl-service-key: "path/to/privatekeyfile.key"
    # ssl-service-pem: "path/to/publiccertfile.pem"
    # ssl-port: 443

    # request upstream over SSL (with plain DNS inside the SSL stream).
    # Default is no.  Can be turned on and off with unbound-control.
    # ssl-upstream: no

    {% if salt['pillar.get']('unbound:dns64-prefix', False) %}
    # DNS64 prefix. Must be specified when DNS64 is use.
    # Enable dns64 in module-config.  Used to synthesize IPv6 from IPv4.
    dns64-prefix: {{ salt['pillar.get']('unbound:dns64-prefix') }}
    {% endif %}

# Remote control config section. 
remote-control:
    # Enable remote control with unbound-control(8) here.
    # set up the keys and certificates with unbound-control-setup.
    control-enable: yes

    # what interfaces are listened to for remote control.
    # give 0.0.0.0 and ::0 to listen to all interfaces.
    control-interface: ::1

    # port number for remote control operations.
    # control-port: 8953

    # unbound server key file.
    server-key-file: "/etc/unbound/unbound_server.key"

    # unbound server certificate file.
    server-cert-file: "/etc/unbound/unbound_server.pem"

    # unbound-control key file.
    control-key-file: "/etc/unbound/unbound_control.key"

    # unbound-control certificate file.
    control-cert-file: "/etc/unbound/unbound_control.pem"

{% if salt['pillar.get']('unbound:stub-zone', False) %}
# Stub zones.
# Create entries like below, to make all queries for 'example.com' and 
# 'example.org' go to the given list of nameservers. list zero or more 
# nameservers by hostname or by ipaddress. If you set stub-prime to yes, 
# the list is treated as priming hints (default is no).
# With stub-first yes, it attempts without the stub if it fails.
{% for sz in salt['pillar.get']('unbound:stub-zone') %}
stub-zone:
  name: "{{ sz['name'] }}"
  {% for addr in sz['addrs'] %}
  stub-addr: {{ addr }}
  {% endfor %}
  stub-prime: {{ 'yes' if sz.get('prime', False) else 'no' }}
  stub-first: {{ 'yes' if sz.get('first', False) else 'no' }}
{% endfor %}
{% endif %}


{% if salt['pillar.get']('unbound:forward-zone', False) %}
# Forward zones
# Create entries like below, to make all queries for 'example.com' and
# 'example.org' go to the given list of servers. These servers have to handle
# recursion to other nameservers. List zero or more nameservers by hostname
# or by ipaddress. Use an entry with name "." to forward all queries.
# If you enable forward-first, it attempts without the forward if it fails.
{% for fz in salt['pillar.get']('unbound:forward-zone') %}
forward-zone:
  name: "{{ fz['name'] }}"
  {% for addr in fz['addrs'] %}
  forward-addr: {{ addr }}
  {% endfor %}
  forward-first: {{ 'yes' if fz.get('first', False) else 'no' }}
{% endfor %}
{% endif %}
