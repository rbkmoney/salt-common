{% set collectd_conf = salt['pillar.get']('collectd:conf', {}) %}
{% set configured_plugins = salt['pillar.get']('collectd:configured-plugins', '') %}
{% set p_aggregation = salt['pillar.get']('collectd:aggregation', False) -%}
{% set p_ceph = salt['pillar.get']('collectd:ceph', False) -%}
{% set p_network = salt['pillar.get']('collectd:network', False) -%}
{% set p_mysql = salt['pillar.get']('collectd:mysql', False) -%}
{% set p_write_graphite = salt['pillar.get']('collectd:write_graphite', False) -%}
{% set p_write_riemann = salt['pillar.get']('collectd:write_riemann', False) -%}
FQDNLookup {{ collectd_conf.get('FQDNLookup', 'true') }}
BaseDir     "/var/lib/collectd"
PIDFile     "/run/collectd/collectd.pid"
TypesDB     "/etc/collectd/types.db"
# PluginDir   "/usr/lib64/collectd"

#----------------------------------------------------------------------------#
# When enabled, plugins are loaded automatically with the default options    #
# when an appropriate <Plugin ...> block is encountered.                     #
# Disabled by default.                                                       #
#----------------------------------------------------------------------------#
AutoLoadPlugin {{ 'true' if 'include' in configured_plugins else 'false' }}

#----------------------------------------------------------------------------#
# Interval at which to query values. This may be overwritten on a per-plugin #
# base by using the 'Interval' option of the LoadPlugin block:               #
#   <LoadPlugin foo>                                                         #
#       Interval 60                                                          #
#   </LoadPlugin>                                                            #
#----------------------------------------------------------------------------#
Interval 10

Timeout {{ collectd_conf.get('Timeout', 2) }}
ReadThreads {{ collectd_conf.get('ReadThreads', 5) }}
WriteThreads {{ collectd_conf.get('WriteThreads', 5) }}

# Limit the size of the write queue. Default is no limit. Setting up a limit is
# recommended for servers handling a high volume of traffic.
#WriteQueueLimitHigh 1000000
#WriteQueueLimitLow   800000
##############################################################################
# Logging                                                                    #
#----------------------------------------------------------------------------#
# Plugins which provide logging functions should be loaded first, so log     #
# messages generated when loading or configuring other plugins can be        #
# accessed.                                                                  #
##############################################################################

LoadPlugin syslog
##LoadPlugin logfile

<Plugin syslog>
  LogLevel info
</Plugin>

#<Plugin logfile>
#	LogLevel info
#	File STDOUT
#	Timestamp true
#	PrintSeverity false
#</Plugin>

##############################################################################
# LoadPlugin section                                                         #
#----------------------------------------------------------------------------#
# Lines beginning with a single `#' belong to plugins which have been built  #
# but are disabled by default.                                               #
#                                                                            #
# Lines begnning with `##' belong to plugins which have not been built due   #
# to missing dependencies or because they have been deactivated explicitly.  #
##############################################################################
{% if p_aggregation %}
LoadPlugin aggregation
{% endif %}
##LoadPlugin amqp
##LoadPlugin apache
{% if 'apcups' in configured_plugins %}
LoadPlugin apcups
{% endif %}
##LoadPlugin apple_sensors
##LoadPlugin aquaero
##LoadPlugin ascent
##LoadPlugin battery
# LoadPlugin bind
#LoadPlugin conntrack
{% if p_ceph %}
LoadPlugin ceph
{% endif %}
LoadPlugin contextswitch
LoadPlugin cpu
{% if not virtual_machine and machine_type not in ('raspberrypi') %}
LoadPlugin cpufreq
LoadPlugin irq
LoadPlugin numa
LoadPlugin sensors
{% endif %}
##LoadPlugin csv
##LoadPlugin curl
##LoadPlugin curl_json
##LoadPlugin curl_xml
{% if "dbi" in configured_plugins %}
LoadPlugin dbi
{% endif %}
LoadPlugin df
LoadPlugin disk
LoadPlugin entropy
LoadPlugin ethstat
LoadPlugin exec
##LoadPlugin filecount
##LoadPlugin fscache
#LoadPlugin gmond
{% if "hddtemp" in configured_plugins %}
LoadPlugin hddtemp
{% endif %}
LoadPlugin interface
{% if "iptables" in configured_plugins %}
LoadPlugin iptables
{% endif %}
{% if "ipmi" in configured_plugins %}
LoadPlugin ipmi
{% endif %}
{% if False %}
##LoadPlugin ipvs
{% endif %}
{% if False %}
##LoadPlugin java
##LoadPlugin libvirt
{% endif %}
LoadPlugin load
##LoadPlugin lpar
##LoadPlugin lvm
##LoadPlugin madwifi
##LoadPlugin mbmon
{% if "mdraid" in configured_plugins %}
LoadPlugin md
{% endif %}
{% if "memcachec" in configured_plugins %}
LoadPlugin memcachec
{% endif %}
{% if "memcached" in configured_plugins %}
LoadPlugin memcached
{% endif %}
LoadPlugin memory
##LoadPlugin modbus
##LoadPlugin multimeter
{% if p_mysql %}
LoadPlugin mysql
{% endif %}
##LoadPlugin netapp
##LoadPlugin netlink
{% if p_network -%}
LoadPlugin network
{% endif %}
{% if nfs_server %}
LoadPlugin nfs
{% endif %}
{% if "nginx" in configured_plugins %}
LoadPlugin nginx
{% endif %}
#LoadPlugin notify_desktop
#LoadPlugin notify_email
# LoadPlugin ntpd
##LoadPlugin nut
##LoadPlugin olsrd
##LoadPlugin onewire
##LoadPlugin openvpn
##LoadPlugin oracle
{% if "perl" in configured_plugins %}
<LoadPlugin perl>
  Globals true
</LoadPlugin>
{% endif %}
##LoadPlugin pinba
# LoadPlugin ping
##LoadPlugin postgresql
##LoadPlugin powerdns
LoadPlugin processes
##LoadPlugin protocols
{% if "python" in configured_plugins %}
<LoadPlugin python>
  Globals true
</LoadPlugin>
{% endif %}
##LoadPlugin redis
##LoadPlugin routeros
#LoadPlugin rrdcached
#LoadPlugin rrdtool
##LoadPlugin serial
##LoadPlugin sigrok
{% if "snmp" in configured_plugins %}
LoadPlugin snmp
{% endif %}
LoadPlugin statsd
##LoadPlugin swap
##LoadPlugin table
LoadPlugin tail
#LoadPlugin tail_csv
##LoadPlugin tape
#LoadPlugin tcpconns
##LoadPlugin teamspeak2
##LoadPlugin ted
#LoadPlugin thermal
##LoadPlugin tokyotyrant
LoadPlugin unixsock
LoadPlugin uptime
LoadPlugin users
##LoadPlugin uuid
##LoadPlugin varnish
##LoadPlugin mic
LoadPlugin vmem
##LoadPlugin vserver
##LoadPlugin wireless
{% if p_write_graphite %}
LoadPlugin write_graphite
{% endif %}
##LoadPlugin write_http
##LoadPlugin write_mongodb
##LoadPlugin write_redis
{% if p_write_riemann %}
LoadPlugin write_riemann
{% endif %}
##LoadPlugin zfs_arc
{% if "xencpu" in configured_plugins %}
LoadPlugin xencpu
{% endif %}
##############################################################################
# Plugin configuration                                                       #
#----------------------------------------------------------------------------#
# In this section configuration stubs for each plugin are provided. A desc-  #
# ription of those options is available in the collectd.conf(5) manual page. #
##############################################################################
{% if p_aggregation %}
<Plugin aggregation>
  {% for aggregation in p_aggregation.get('aggregations') %}
  <Aggregation>
    {{ 'Host "'+aggregation['host']+'"' if aggregation.get('host', False) else '# Host ""' }}
    {{ 'Plugin "'+aggregation['plugin']+'"' if aggregation.get('plugin', False) else '# Plugin ""' }}
    {{ 'PluginInstance "'+aggregation['plugin-instance']+'"' if aggregation.get('plugin-instance', False) else '# PluginInstance ""' }}
    {{ 'Type "'+aggregation['type']+'"' if aggregation.get('type', False) else '# Type ""' }}
    {{ 'TypeInstance "'+aggregation['type-instance']+'"' if aggregation.get('type-instance', False) else '# TypeInstance ""' }}

    {% for what in aggregation.get('group-by', []) %}
    GroupBy "{{ what }}"
    {% endfor -%}
    {% set calculate = aggregation.get('calculate', []) %}
    {% for func in ('num', 'sum', 'average', 'minimum', 'maximum', 'stddev') -%}
    Calculate{{ func.capitalize() }} {{ 'true' if func in calculate else 'false' }}
    {% endfor -%}
  </Aggregation>
  {% endfor %}
</Plugin>
{% endif %}
{% if False %}
#<Plugin "amqp">
#  <Publish "name">
#    Host "localhost"
#    Port "5672"
#    VHost "/"
#    User "guest"
#    Password "guest"
#    Exchange "amq.fanout"
#    RoutingKey "collectd"
#    Persistent false
#    StoreRates false
#  </Publish>
#</Plugin>

#<Plugin apache>
#  <Instance "local">
#    URL "http://localhost/status?auto"
#    User "www-user"
#    Password "secret"
#    CACert "/etc/ssl/ca.crt"
#  </Instance>
#</Plugin>
{% endif %}
{% if 'apcups' in configured_plugins %}
<Plugin apcups>
  Host "localhost"
  Port "3551"
  ReportSeconds true
</Plugin>
{% endif %}
{% if False %}
#<Plugin ascent>
#	URL "http://localhost/ascent/status/"
#	User "www-user"
#	Password "secret"
#	CACert "/etc/ssl/ca.crt"
#</Plugin>

# <Plugin "bind">
#   URL "http://localhost:8053/"
#   ParseTime       true
#   OpCodes         false
#   QTypes          false

#   ServerStats     true
#   ZoneMaintStats  true
#   # ResolverStats   false
#   MemoryStats     false

#   <View "_default">
#   #  QTypes        true
#      ResolverStats true
#   #  CacheRRSets   true

#   #  Zone "127.in-addr.arpa/IN"
#   </View>
# </Plugin>

#<Plugin csv>
#	DataDir "/var/lib/collectd/csv"
#	StoreRates false
#</Plugin>

#<Plugin curl>
#  <Page "stock_quotes">
#    URL "http://finance.google.com/finance?q=NYSE%3AAMD"
#    User "foo"
#    Password "bar"
#    MeasureResponseTime false
#    <Match>
#      Regex "<span +class=\"pr\"[^>]*> *([0-9]*\\.[0-9]+) *</span>"
#      DSType "GaugeAverage"
#      Type "stock_value"
#      Instance "AMD"
#    </Match>
#  </Page>
#</Plugin>

#<Plugin curl_json>
## See: http://wiki.apache.org/couchdb/Runtime_Statistics
#  <URL "http://localhost:5984/_stats">
#    Instance "httpd"
#    <Key "httpd/requests/count">
#      Type "http_requests"
#    </Key>
#
#    <Key "httpd_request_methods/*/count">
#      Type "http_request_methods"
#    </Key>
#
#    <Key "httpd_status_codes/*/count">
#      Type "http_response_codes"
#    </Key>
#  </URL>
## Database status metrics:
#  <URL "http://localhost:5984/_all_dbs">
#    Instance "dbs"
#    <Key "*/doc_count">
#      Type "gauge"
#    </Key>
#    <Key "*/doc_del_count">
#      Type "counter"
#    </Key>
#    <Key "*/disk_size">
#      Type "bytes"
#    </Key>
#  </URL>
#</Plugin>

#<Plugin "curl_xml">
#  <URL "http://localhost/stats.xml">
#    Host "my_host"
#    Instance "some_instance"
#    User "collectd"
#    Password "thaiNg0I"
#    VerifyPeer true
#    VerifyHost true
#    CACert "/path/to/ca.crt"
#
#    <XPath "table[@id=\"magic_level\"]/tr">
#      Type "magic_level"
#      #InstancePrefix "prefix-"
#      InstanceFrom "td[1]"
#      ValuesFrom "td[2]/span[@class=\"level\"]"
#    </XPath>
#  </URL>
#</Plugin>
{% endif %}
{% if p_ceph %}
<Plugin ceph>
  {% for cluster in p_ceph['cluster'] %}
  {% for daemon in p_ceph['cluster'][cluster] %}
  <Daemon "{{ daemon }}">
    SocketPath "/var/run/ceph/{{ cluster }}-{{ daemon }}.asok"
  </Daemon>
  {% endfor %}
  {% endfor %}
</Plugin>
{% endif %}
<Plugin df>
#	Device "/dev/hda1"
#	Device "192.168.0.2:/mnt/nfs"
#	MountPoint "/home"
  	# FSType "cgroup_root"
  Device "cgroup_root"
  Device "devtmpfs"
  Device "rootfs"
  Device "/^docker-.+/"
  Device "/^mapper_docker-.+/"
  IgnoreSelected true
  ReportByDevice true
  ReportInodes true
</Plugin>
<Plugin disk>
  Disk "/^[hs]d[a-z]$/"
  Disk "/^xvd[a-z]$/"
  Disk "/^md[0-9]+$/"
  IgnoreSelected false
</Plugin>

<Plugin ethstat>
	Map "rx_csum_offload_errors" "if_rx_errors" "checksum_offload"
	Map "multicast" "if_multicast"
	MappedOnly false
</Plugin>

<Plugin exec>
{% if False %}
# #	Exec "user:group" "/path/to/exec"
# #	NotificationExec "user:group" "/path/to/exec"
#	Exec "collectd" "/usr/local/bin/ksm_stats.sh"
{% endif %}
</Plugin>
{% if False %}
#<Plugin filecount>
#	<Directory "/path/to/dir">
#		Instance "foodir"
#		Name "*.conf"
#		MTime "-5m"
#		Size "+10k"
#		Recursive true
#		IncludeHidden false
#	</Directory>
#</Plugin>
{% endif %}
{% if False %}
#<Plugin "gmond">
#  MCReceiveFrom "239.2.11.71" "8649"
#  <Metric "swap_total">
#    Type "swap"
#    TypeInstance "total"
#    DataSource "value"
#  </Metric>
#  <Metric "swap_free">
#    Type "swap"
#    TypeInstance "free"
#    DataSource "value"
#  </Metric>
#</Plugin>
{% endif %}
{% if "hddtemp" in configured_plugins %}
<Plugin hddtemp>
  Host "127.0.0.1"
  Port "7634"
</Plugin>
{% endif %}

<Plugin interface>
  Interface "/^veth.+/"
  IgnoreSelected true
</Plugin>

{% if "ipmi" in configured_plugins %}
<Plugin ipmi>
#	Sensor "some_sensor"
#	Sensor "another_one"
	IgnoreSelected true
	NotifySensorAdd false
	NotifySensorRemove true
	NotifySensorNotPresent false
</Plugin>
{% endif %}
{% if "iptables" in configured_plugins %}
<Plugin iptables>
	Chain filter check-flags
</Plugin>
{% endif %}
{% if False %}
#<Plugin "java">
#	JVMArg "-verbose:jni"
#	JVMArg "-Djava.class.path=/usr/share/collectd/java/collectd-api.jar"
#
#	LoadPlugin "org.collectd.java.Foobar"
#	<Plugin "org.collectd.java.Foobar">
#	  # To be parsed by the plugin
#	</Plugin>
#</Plugin>

#<Plugin libvirt>
#	Connection "xen:///"
#	RefreshInterval 60
#	Domain "name"
#	BlockDevice "name:device"
#	InterfaceDevice "name:device"
#	IgnoreSelected false
#	HostnameFormat name
#	InterfaceFormat name
#</Plugin>

#<Plugin lpar>
#	CpuPoolStats   false
#	ReportBySerial false
#</Plugin>

#<Plugin madwifi>
#	Interface "wlan0"
#	IgnoreSelected false
#	Source "SysFS"
#	WatchSet "None"
#	WatchAdd "node_octets"
#	WatchAdd "node_rssi"
#	WatchAdd "is_rx_acl"
#	WatchAdd "is_scan_active"
#</Plugin>

#<Plugin mbmon>
#	Host "127.0.0.1"
#	Port "411"
#</Plugin>
{% endif %}
{% if "mdraid" in configured_plugins %}
<Plugin md>
  Device "/dev/md0"
  IgnoreSelected true
</Plugin>
{% endif %}
<Plugin memory>
  ValuesPercentage true
</Plugin>
{% if "memcachec" in configured_plugins %}
<Plugin memcachec>
	<Page "plugin_instance">
		Server "localhost"
		Key "page_key"
		<Match>
			Regex "(\\d+) bytes sent"
			ExcludeRegex "<lines to be excluded>"
			DSType CounterAdd
			Type "ipt_octets"
			Instance "type_instance"
		</Match>
	</Page>
</Plugin>
{% endif %}
{% if "memcached" in configured_plugins %}
<Plugin memcached>
	Host "127.0.0.1"
	Port "11211"
</Plugin>
{% endif %}
{% if False %}
#<Plugin modbus>
#	<Data "data_name">
#		RegisterBase 1234
#		RegisterType float
#		Type gauge
#		Instance "..."
#	</Data>
#
#	<Host "name">
#		Address "addr"
#		Port "1234"
#		Interval 60
#
#		<Slave 1>
#			Instance "foobar" # optional
#			Collect "data_name"
#		</Slave>
#	</Host>
#</Plugin>
{% endif %}
{% if p_mysql %}
<Plugin mysql>
	{% for database in p_mysql.get('databases') %}
	<Database {{ database['instance'] }}>
		Host "{{ database['host'] }}"
		{{ 'Socket "' + database['socket'] + '"' if database.get('socket', False) else '# Socket ""' }}
		User "{{ database['user'] }}"
		Password "{{ database['password'] }}"
		{{ 'Database "' + database['database'] + '"' if database.get('database', False) else '# Database ""' }}
		MasterStats {{ 'true' if database.get('master-stats', False) else 'false' }}
		SlaveStats {{ 'true' if database.get('slave-stats', False) else 'false' }}
		SlaveNotifications {{ 'true' if database.get('slave-notification', False) else 'false' }}
	</Database>
	{% endfor %}
</Plugin>
{% endif %}
{% if False %}
#<Plugin netapp>
#	<Host "netapp1.example.com">
#		Protocol      "https"
#		Address       "10.0.0.1"
#		Port          443
#		User          "username"
#		Password      "aef4Aebe"
#		Interval      30
#
#		<WAFL>
#			Interval 30
#			GetNameCache   true
#			GetDirCache    true
#			GetBufferCache true
#			GetInodeCache  true
#		</WAFL>
#
#		<Disks>
#			Interval 30
#			GetBusy true
#		</Disks>
#
#		<VolumePerf>
#			Interval 30
#			GetIO      "volume0"
#			IgnoreSelectedIO      false
#			GetOps     "volume0"
#			IgnoreSelectedOps     false
#			GetLatency "volume0"
#			IgnoreSelectedLatency false
#		</VolumePerf>
#
#		<VolumeUsage>
#			Interval 30
#			GetCapacity "vol0"
#			GetCapacity "vol1"
#			IgnoreSelectedCapacity false
#			GetSnapshot "vol1"
#			GetSnapshot "vol3"
#			IgnoreSelectedSnapshot false
#		</VolumeUsage>
#
#		<System>
#			Interval 30
#			GetCPULoad     true
#			GetInterfaces  true
#			GetDiskOps     true
#			GetDiskIO      true
#		</System>
#	</Host>
#</Plugin>

#<Plugin netlink>
#	Interface "All"
#	VerboseInterface "All"
#	QDisc "eth0" "pfifo_fast-1:0"
#	Class "ppp0" "htb-1:10"
#	Filter "ppp0" "u32-1:0"
#	IgnoreSelected false
#</Plugin>
{% endif %}

{% if p_network -%}
<Plugin network>
  {% for server in p_network.get('servers', []) %}
  <Server "{{ server['name'] }}" "{{ server['port'] }}">
    SecurityLevel {{ server.get('security-level', 'Encrypt') }}
    Username "{{ server ['username'] }}"
    Password "{{ server ['password'] }}"
  </Server>
  {% endfor %}
  {% for listen in p_network.get('listen', []) %}
  <Listen "{{ listen.get('addr', '::') }}" "{{ listen['port'] }}">
    SecurityLevel {{ listen.get('security-level', 'Sign') }}
    AuthFile "{{ listen.get('auth-file', '/etc/collectd/collectd.passwd') }}"
  </Listen>
  {% endfor %}
  MaxPacketSize {{ p_network.get('max-packet-size', 4096) }}
  # proxy setup (client and server as above):
  Forward {{ 'true' if p_network.get('forward', False) else 'false' }}
  # statistics about the network plugin itself
  ReportStats {{ 'true' if p_network.get('report-stats', True) else 'false' }}
  # "garbage collection"
  # CacheFlush {{ p_network.get('cache-flush', 1800) }}
</Plugin>
{% endif -%}
{% if "nginx" in configured_plugins %}
<Plugin nginx>
	URL "http://localhost/nginx_status"
#	User "status"
#	Password "secret"
#	CACert "/etc/ssl/ca.crt"
</Plugin>
{% endif %}
{% if False %}
#<Plugin notify_email>
#       SMTPServer "localhost"
#	SMTPPort 25
#	SMTPUser "my-username"
#	SMTPPassword "my-password"
#	From "collectd@main0server.com"
#	# <WARNING/FAILURE/OK> on <hostname>. beware! do not use not more than two %s in this string!!!
#	Subject "Aaaaaa!! %s on %s!!!!!"
#	Recipient "email1@domain1.net"
#	Recipient "email2@domain2.com"
#</Plugin>

#<Plugin nut>
#	UPS "upsname@hostname:port"
#</Plugin>

#<Plugin olsrd>
#	Host "127.0.0.1"
#	Port "2006"
#	CollectLinks "Summary"
#	CollectRoutes "Summary"
#	CollectTopology "Summary"
#</Plugin>

#<Plugin onewire>
#	Device "-s localhost:4304"
#	Sensor "F10FCA000800"
#	IgnoreSelected false
#</Plugin>

#<Plugin openvpn>
#	StatusFile "/etc/openvpn/openvpn-status.log"
#	ImprovedNamingSchema true
#	CollectCompression true
#	CollectIndividualUsers true
#	CollectUserCount false
#</Plugin>

#<Plugin oracle>
#  <Query "out_of_stock">
#    Statement "SELECT category, COUNT(*) AS value FROM products WHERE in_stock = 0 GROUP BY category"
#    <Result>
#      Type "gauge"
#      InstancesFrom "category"
#      ValuesFrom "value"
#    </Result>
#  </Query>
#  <Database "product_information">
#    ConnectID "db01"
#    Username "oracle"
#    Password "secret"
#    Query "out_of_stock"
#  </Database>
#</Plugin>

#<Plugin perl>
#	IncludeDir "/my/include/path"
#	BaseName "Collectd::Plugins"
#	EnableDebugger ""
#	LoadPlugin Monitorus
#	LoadPlugin OpenVZ
#
#	<Plugin foo>
#		Foo "Bar"
#		Qux "Baz"
#	</Plugin>
#</Plugin>

#<Plugin pinba>
#	Address "::0"
#	Port "30002"
#	<View "name">
#		Host "host name"
#		Server "server name"
#		Script "script name"
#	</View>
#</Plugin>

#<Plugin ping>
#	Host "host.foo.bar"
#	Interval 1.0
#	Timeout 0.9
#	TTL 255
#	SourceAddress "1.2.3.4"
#	Device "eth0"
#	MaxMissed -1
#</Plugin>

#<Plugin postgresql>
#	<Query magic>
#		Statement "SELECT magic FROM wizard WHERE host = $1;"
#		Param hostname
#		<Result>
#			Type gauge
#			InstancePrefix "magic"
#			ValuesFrom magic
#		</Result>
#	</Query>
#	<Query rt36_tickets>
#		Statement "SELECT COUNT(type) AS count, type \
#		                  FROM (SELECT CASE \
#		                               WHEN resolved = 'epoch' THEN 'open' \
#		                               ELSE 'resolved' END AS type \
#		                               FROM tickets) type \
#		                  GROUP BY type;"
#		<Result>
#			Type counter
#			InstancePrefix "rt36_tickets"
#			InstancesFrom "type"
#			ValuesFrom "count"
#		</Result>
#	</Query>
#	<Writer sqlstore>
#		# See contrib/postgresql/collectd_insert.sql for details
#		Statement "SELECT collectd_insert($1, $2, $3, $4, $5, $6, $7, $8, $9);"
#		StoreRates true
#	</Writer>
#	<Database foo>
#		Host "hostname"
#		Port "5432"
#		User "username"
#		Password "secret"
#		SSLMode "prefer"
#		KRBSrvName "kerberos_service_name"
#		Query magic
#	</Database>
#	<Database bar>
#		Interval 60
#		Service "service_name"
#		Query backend # predefined
#		Query rt36_tickets
#	</Database>
#	<Database qux>
#		Service "collectd_store"
#		Writer sqlstore
#		# see collectd.conf(5) for details
#		CommitInterval 30
#	</Database>
#</Plugin>

#<Plugin powerdns>
#  <Server "server_name">
#    Collect "latency"
#    Collect "udp-answers" "udp-queries"
#    Socket "/var/run/pdns.controlsocket"
#  </Server>
#  <Recursor "recursor_name">
#    Collect "questions"
#    Collect "cache-hits" "cache-misses"
#    Socket "/var/run/pdns_recursor.controlsocket"
#  </Recursor>
#  LocalSocket "/opt/collectd/var/run/collectd-powerdns"
#</Plugin>

#<Plugin processes>
#	Process "name"
#</Plugin>

#<Plugin protocols>
#	Value "/^Tcp:/"
#	IgnoreSelected false
#</Plugin>

# <Plugin python>
# 	ModulePath "/usr/local/share/collectd"
# 	LogTraces true
# 	Interactive false
# 	Import "cgminer-collectd"
# 	<Module "cgminer-collectd">
# 		addr "127.0.0.1" "4028"
# 		Want "summary" "devs" "pools" "coin"
# 		WantFromSummary "MHS av"
# 		WantFromGPU "MHS av" "MHS 5s"
# 		WantFromPool "Accepted" "Rejected" "Discarded" "Stale"
# 		WantFromCoin "Network Difficulty"
# 	</Module>
# </Plugin>

#<Plugin redis>
#   <Node example>
#      Host "redis.example.com"
#      Port "6379"
#      Timeout 2000
#   </Node>
#</Plugin>

#<Plugin routeros>
#	<Router>
#		Host "router.example.com"
#		Port "8728"
#		User "admin"
#		Password "dozaiTh4"
#		CollectInterface true
#		CollectRegistrationTable true
#		CollectCPULoad true
#		CollectMemory true
#		CollectDF true
#		CollectDisk true
#	</Router>
#</Plugin>

#<Plugin rrdcached>
#	DaemonAddress "unix:/tmp/rrdcached.sock"
#	DataDir "/var/lib/collectd/rrd"
#	CreateFiles true
#	CreateFilesAsync false
#	CollectStatistics true
#</Plugin>

#<Plugin rrdtool>
#	DataDir "/var/lib/collectd/rrd"
#	CreateFilesAsync false
#	CacheTimeout 120
#	CacheFlush   900
#	WritesPerSecond 50
#</Plugin>
{% endif %}
{% if not virtual_machine and machine_type not in ("raspberry pi") %}
<Plugin sensors>
	SensorConfigFile "/etc/sensors3.conf"
#	Sensor "it8712-isa-0290/temperature-temp1"
#	Sensor "it8712-isa-0290/fanspeed-fan3"
#	Sensor "it8712-isa-0290/voltage-in8"
#	IgnoreSelected false
</Plugin>
<Plugin irq>
#	Irq 7
#	Irq 8
#	Irq 9
	IgnoreSelected true
</Plugin>
{% endif %}
{% if False %}
#<Plugin sigrok>
#  LogLevel 3
#  <Device "AC Voltage">
#    Driver "fluke-dmm"
#    MinimumInterval 10
#    Conn "/dev/ttyUSB2"
#  </Device>
#  <Device "Sound Level">
#    Driver "cem-dt-885x"
#    Conn "/dev/ttyUSB1"
#  </Device>
#</Plugin>
{% endif %}
{% if False %}
#<Plugin snmp>
#   <Data "powerplus_voltge_input">
#       Type "voltage"
#       Table false
#       Instance "input_line1"
#       Values "SNMPv2-SMI::enterprises.6050.5.4.1.1.2.1"
#   </Data>
#   <Data "hr_users">
#       Type "users"
#       Table false
#       Instance ""
#       Values "HOST-RESOURCES-MIB::hrSystemNumUsers.0"
#   </Data>
#   <Data "std_traffic">
#       Type "if_octets"
#       Table true
#       Instance "IF-MIB::ifDescr"
#       Values "IF-MIB::ifInOctets" "IF-MIB::ifOutOctets"
#   </Data>
#
#   <Host "some.switch.mydomain.org">
#       Address "192.168.0.2"
#       Version 1
#       Community "community_string"
#       Collect "std_traffic"
#       Interval 120
#   </Host>
#   <Host "some.server.mydomain.org">
#       Address "192.168.0.42"
#       Version 2
#       Community "another_string"
#       Collect "std_traffic" "hr_users"
#   </Host>
#   <Host "some.ups.mydomain.org">
#       Address "192.168.0.3"
#       Version 1
#       Community "more_communities"
#       Collect "powerplus_voltge_input"
#       Interval 300
#   </Host>
#</Plugin>
{% endif %}

<Plugin statsd>
  Host "::"
  Port "8125"
  DeleteCounters false
  DeleteTimers   false
  DeleteGauges   false
  DeleteSets     false
  TimerPercentile 90.0
</Plugin>

{% if False %}
#<Plugin "swap">
#	ReportByDevice false
#	ReportBytes true
#</Plugin>

#<Plugin "table">
#	<Table "/proc/slabinfo">
#		Instance "slabinfo"
#		Separator " "
#		<Result>
#			Type gauge
#			InstancePrefix "active_objs"
#			InstancesFrom 0
#			ValuesFrom 1
#		</Result>
#		<Result>
#			Type gauge
#			InstancePrefix "objperslab"
#			InstancesFrom 0
#			ValuesFrom 4
#		</Result>
#	</Table>
#</Plugin>
{% endif %}
<Plugin "tail">
{% if "postfix" in configured_plugins %}
 <File "/var/log/mail.log">
  Instance "postfix"
   # number of connections
   # (incoming)
   <Match>
     Regex "\\<postfix\\/smtpd\\[[0-9]+\\]: connect from\\>"
     DSType "CounterInc"
     Type "mail_counter"
     Instance "connection-in-open"
   </Match>
   <Match>
     Regex "\\<postfix\\/smtpd\\[[0-9]+\\]: disconnect from\\>"
     DSType "CounterInc"
     Type "mail_counter"
     Instance "connection-in-close"
   </Match>
   <Match>
     Regex "\\<postfix\\/smtpd\\[[0-9]+\\]: lost connection after .* from\\>"
     DSType "CounterInc"
     Type "mail_counter"
     Instance "connection-in-lost"
   </Match>
   <Match>
     Regex "\\<postfix\\/smtpd\\[[0-9]+\\]: timeout after .* from\\>"
     DSType "CounterInc"
     Type "mail_counter"
     Instance "connection-in-timeout"
   </Match>
   <Match>
     Regex "\\<postfix\\/smtpd\\[[0-9]+\\]: setting up TLS connection from\\>"
     DSType "CounterInc"
     Type "mail_counter"
     Instance "connection-in-TLS-setup"
   </Match>
   <Match>
     Regex "\\<postfix\\/smtpd\\[[0-9]+\\]: [A-Za-z]+ TLS connection established from\\>"
     DSType "CounterInc"
     Type "mail_counter"
     Instance "connection-in-TLS-established"
   </Match>
   # (outgoing)
   <Match>
     Regex "\\<postfix\\/smtp\\[[0-9]+\\]: setting up TLS connection to\\>"
     DSType "CounterInc"
     Type "mail_counter"
     Instance "connection-out-TLS-setup"
   </Match>
   <Match>
     Regex "\\<postfix\\/smtp\\[[0-9]+\\]: [A-Za-z]+ TLS connection established to\\>"
     DSType "CounterInc"
     Type "mail_counter"
     Instance "connection-out-TLS-established"
   </Match>

  # rejects for incoming E-mails
  <Match>
    Regex "\\<554 5\\.7\\.1\\>"
    DSType "CounterInc"
    Type "mail_counter"
    Instance "rejected"
  </Match>
  <Match>
    Regex "\\<450 4\\.7\\.1\\>.*Helo command rejected: Host not found\\>"
    DSType "CounterInc"
    Type "mail_counter"
    Instance "rejected-host_not_found"
  </Match>
  <Match>
    Regex "\\<450 4\\.7\\.1\\>.*Client host rejected: No DNS entries for your MTA, HELO and Domain\\>"
    DSType "CounterInc"
    Type "mail_counter"
    Instance "rejected-no_dns_entry"
  </Match>
   <Match>
     Regex "\\<450 4\\.7\\.1\\>.*Client host rejected: Mail appeared to be SPAM or forged\\>"
     DSType "CounterInc"
     Type "mail_counter"
     Instance "rejected-spam_or_forged"
   </Match>

  # status codes
  <Match>
    Regex "status=deferred"
    DSType "CounterInc"
    Type "mail_counter"
    Instance "status-deferred"
  </Match>
  <Match>
    Regex "status=forwarded"
    DSType "CounterInc"
    Type "mail_counter"
    Instance "status-forwarded"
  </Match>
  <Match>
    Regex "status=reject"
    DSType "CounterInc"
    Type "mail_counter"
    Instance "status-reject"
  </Match>
  <Match>
    Regex "status=sent"
    DSType "CounterInc"
    Type "mail_counter"
    Instance "status-sent"
  </Match>
  <Match>
    Regex "status=bounced"
    DSType "CounterInc"
    Type "mail_counter"
    Instance "status-bounced"
  </Match>
  <Match>
    Regex "status=SOFTBOUNCE"
    DSType "CounterInc"
    Type "mail_counter"
    Instance "status-softbounce"
  </Match>

  # message size
  <Match>
    Regex "size=([0-9]*)"
    DSType "CounterAdd"
    Type "ipt_bytes"
    Instance "size"
  </Match>

  # delays
  # total time spent in the Postfix queue
  <Match>
    Regex "delay=([\.0-9]*)"
    DSType "GaugeAverage"
    Type "gauge"
    Instance "delay"
  </Match>
  # time spent before the queue manager, including message transmission
  <Match>
    Regex "delays=([\.0-9]*)/[\.0-9]*/[\.0-9]*/[\.0-9]*"
    DSType "GaugeAverage"
    Type "gauge"
    Instance "delay-before_queue_mgr"
  </Match>
  # time spent in the queue manager
  <Match>
    Regex "delays=[\.0-9]*/([\.0-9]*)/[\.0-9]*/[\.0-9]*"
    DSType "GaugeAverage"
    Type "gauge"
    Instance "delay-in_queue_mgr"
  </Match>
  # connection setup time including DNS, HELO and TLS
  <Match>
    Regex "delays=[\.0-9]*/[\.0-9]*/([\.0-9]*)/[\.0-9]*"
    DSType "GaugeAverage"
    Type "gauge"
    Instance "delay-setup_time"
  </Match>
  # message transmission time
  <Match>
    Regex "delays=[\.0-9]*/[\.0-9]*/[\.0-9]*/([\.0-9]*)"
    DSType "GaugeAverage"
    Type "gauge"
    Instance "delay-trans_time"
  </Match>
</File>
{% endif %}
{% if "nginx" in configured_plugins %}
<File "/var/log/nginx/access_log">
  Instance "nginx"
  <Match>
    Regex " \\[5..\\] "
    DSType "DeriveInc"
    Type "derive"
    Instance "5xx"
  </Match>
  <Match>
    Regex " \\[4..\\] "
    DSType "DeriveInc"
    Type "derive"
    Instance "4xx"
  </Match>
  <Match>
    Regex " \\[3..\\] "
    DSType "DeriveInc"
    Type "derive"
    Instance "3xx"
  </Match>
  <Match>
    Regex "\\[2..\\]"
    DSType "DeriveInc"
    Type "derive"
    Instance "2xx"
  </Match>
  <Match>
    Regex " \\[1..\\] "
    DSType "DeriveInc"
    Type "derive"
    Instance "1xx"
  </Match>
 </File>
{% endif %}
</Plugin>
{% if False %}
#<Plugin "tail_csv">
#   <Metric "dropped">
#       Type "percent"
#       Instance "dropped"
#       ValueFrom 1
#   </Metric>
#   <Metric "mbps">
#       Type "bytes"
#       Instance "wire-realtime"
#       ValueFrom 2
#   </Metric>
#   <Metric "alerts">
#       Type "alerts_per_second"
#       ValueFrom 3
#   </Metric>
#   <Metric "kpps">
#       Type "kpackets_wire_per_sec.realtime"
#       ValueFrom 4
#   </Metric>
#   <File "/var/log/snort/snort.stats">
#       Instance "snort-eth0"
#       Interval 600
#       Collect "dropped" "mbps" "alerts" "kpps"
#       TimeFrom 0
#   </File>
#</Plugin>
#<Plugin tcpconns>
#	ListeningPorts false
#	LocalPort "25"
#	RemotePort "25"
#</Plugin>
#<Plugin teamspeak2>
#	Host "127.0.0.1"
#	Port "51234"
#	Server "8767"
#</Plugin>
#<Plugin ted>
#	Device "/dev/ttyUSB0"
#	Retries 0
#</Plugin>
#<Plugin thermal>
#	ForceUseProcfs false
#	Device "THRM"
#	IgnoreSelected false
#</Plugin>
#<Plugin tokyotyrant>
#	Host "localhost"
#	Port "1978"
#</Plugin>
{% endif %}

<Plugin unixsock>
	SocketFile "/run/collectd/collectd.sock"
	SocketGroup "nagios"
	SocketPerms "0660"
#	DeleteSocket false
</Plugin>

{% if False %}
#<Plugin uuid>
#	UUIDFile "/etc/uuid"
#</Plugin>
{% endif %}
{% if False %}
#<Plugin mic>
#   ShowCPU true
#   ShowCPUCores true
#   ShowMemory true
#   ShowTemperatures true
##  Temperature Sensors can be ignored/shown by repeated #Temperature lines, and
##  then inverted with a IgnoreSelectedTemperature.
##  Known Temperature sensors: die, devmem, fin, fout, vccp, vddg, vddq
#   Temperature vddg
#   IgnoreSelectedTemperature true
#   ShowPower true
##  Power Sensors can be ignored/shown by repeated #Power lines, and
##  then inverted with a IgnoreSelectedTemperature.
##  Known Temperature sensors: total0, total1, inst, imax, pci3, c2x3, c2x4, vccp, vddg, vddq
#   Power total1
#   IgnoreSelectedPower true
#</Plugin>
{% endif %}
{% if False %}
#<Plugin varnish>
#   This tag support an argument if you want to
#   monitor the local instance just use </Instance>
#   If you prefer defining another instance you can do
#   so by using <Instance "myinstance">
#   <Instance>
#      CollectCache true
#      CollectBackend true
#      CollectBan false           # Varnish 3 only
#      CollectConnections true
#      CollectDirectorDNS false   # Varnish 3 only
#      CollectSHM true
#      CollectESI false
#      CollectFetch false
#      CollectHCB false
#      CollectObjects false
#      CollectPurge false         # Varnish 2 only
#      CollectSession false
#      CollectSMA false           # Varnish 2 only
#      CollectSMS false
#      CollectSM false            # Varnish 2 only
#      CollectStruct false
#      CollectTotals false
#      CollectUptime false
#      CollectVCL false
#      CollectWorkers false
#   </Instance>
#</Plugin>
{% endif %}

<Plugin vmem>
	Verbose false
</Plugin>

{% if p_write_graphite %}
<Plugin write_graphite>
  {% for carbon in p_write_graphite['carbons'] %}
  <Carbon>
    Host "{{ carbon['host'] }}"
    Protocol "{{ carbon.get('protocol', 'tcp') }}"
    Port "{{ carbon.get('port', '2003') }}"
    Prefix "{{ carbon.get('prefix', 'collectd.') }}"
    Postfix "{{ carbon.get('postfix', '') }}"
    StoreRates {{ 'true' if carbon.get('store-rates', True) else 'false' }}
    EscapeCharacter "{{ carbon.get('escape-character', '_') }}"
  </Carbon>
  {% endfor %}
</Plugin>
{% endif %}
{% if False %}
#<Plugin write_http>
#	<URL "http://example.com/collectd-post">
#		User "collectd"
#		Password "weCh3ik0"
#		VerifyPeer true
#		VerifyHost true
#		CACert "/etc/ssl/ca.crt"
#		Format "Command"
#		StoreRates false
#	</URL>
#</Plugin>

#<Plugin write_mongodb>
#	<Node "example">
#		Host "localhost"
#		Port "27017"
#		Timeout 1000
#		StoreRates false
#		Database "auth_db"
#		User "auth_user"
#		Password "auth_passwd"
#	</Node>
#</Plugin>

#<Plugin write_redis>
#	<Node "example">
#		Host "localhost"
#		Port "6379"
#		Timeout 1000
#	</Node>
#</Plugin>
{% endif %}

{% if p_write_riemann %}
<Plugin write_riemann>
  {% for node in p_write_riemann['nodes'] %}
  <Node {{ node['name'] }}>
    Host "{{ node['host'] }}"
    Protocol "{{ node.get('protocol', 'UDP') }}"
    Port "{{ node.get('port', '5555') }}"
    StoreRates {{ 'true' if node.get('store-rates', True) else 'false' }}
    AlwaysAppendDS {{ 'true' if node.get('always-append-ds', False) else 'false' }}
  </Node>
  {% endfor %}
  {% for tag in p_write_riemann.get('tags', []) %}
  Tag "{{tag}}"
  {% endfor %}
</Plugin>
{% endif %}
{% if False %}
##############################################################################
# Filter configuration                                                       #
#----------------------------------------------------------------------------#
# The following configures collectd's filtering mechanism. Before changing   #
# anything in this section, please read the `FILTER CONFIGURATION' section   #
# in the collectd.conf(5) manual page.                                       #
##############################################################################

# Load required matches:
##LoadPlugin match_empty_counter
##LoadPlugin match_hashed
##LoadPlugin match_regex
##LoadPlugin match_value
##LoadPlugin match_timediff

# Load required targets:
##LoadPlugin target_notification
##LoadPlugin target_replace
##LoadPlugin target_scale
##LoadPlugin target_set
##LoadPlugin target_v5upgrade

#----------------------------------------------------------------------------#
# The following block demonstrates the default behavior if no filtering is   #
# configured at all: All values will be sent to all available write plugins. #
#----------------------------------------------------------------------------#

#<Chain "PostCache">
#  Target "write"
#</Chain>

##############################################################################
# Threshold configuration                                                    #
#----------------------------------------------------------------------------#
# The following outlines how to configure collectd's threshold checking      #
# plugin. The plugin and possible configuration options are documented in    #
# the collectd-threshold(5) manual page.                                     #
##############################################################################

##LoadPlugin "threshold"
#<Plugin "threshold">
#  <Type "foo">
#    WarningMin    0.00
#    WarningMax 1000.00
#    FailureMin    0.00
#    FailureMax 1200.00
#    Invert false
#    Instance "bar"
#  </Type>
#
#  <Plugin "interface">
#    Instance "eth0"
#    <Type "if_octets">
#      FailureMax 10000000
#      DataSource "rx"
#    </Type>
#  </Plugin>
#
#  <Host "hostname">
#    <Type "cpu">
#      Instance "idle"
#      FailureMin 10
#    </Type>
#
#    <Plugin "memory">
#      <Type "memory">
#        Instance "cached"
#        WarningMin 100000000
#      </Type>
#    </Plugin>
#
#    <Type "load">
#    	DataSource "midterm"
#    	FailureMax 4
#    	Hits 3
#    	Hysteresis 3
#    </Type>
#  </Host>
#</Plugin>
{% endif %}

{% if 'include' in configured_plugins %}
<Include "/etc/collectd/conf.d">
  Filter "*.conf"
</Include>
{% endif %}
