{% set collectd = salt.pillar.get('collectd', {}) %}
{% set collectd_conf = collectd.get('conf', {}) %}
{% set extra_plugins = collectd.get('extra-plugins', []) %}
{% set extra_plugin_config = collectd.get('extra-plugin-config', []) %}
{% set p_network = collectd.get('network', False) %}
{% set p_aggregation = collectd.get('aggregation', False) %}
{% set p_write_graphite = collectd.get('write_graphite', False) %}
{% set p_write_riemann = collectd.get('write_riemann', False) %}
{% set p_ceph = collectd.get('ceph', False) %}
{% set p_mysql = collectd.get('mysql', False) %}
{% set p_processes = collectd.get('processes', False) %}
FQDNLookup {{ collectd_conf.get('FQDNLookup', 'true') }}
BaseDir     "/var/lib/collectd"
PIDFile     "/run/collectd/collectd.pid"
TypesDB     "/etc/collectd/types.db"
# PluginDir   "/usr/lib64/collectd"
Include "/etc/collectd/conf.d/*.conf"

#----------------------------------------------------------------------------#
# When enabled, plugins are loaded automatically with the default options    #
# when an appropriate <Plugin ...> block is encountered.                     #
# Disabled by default.                                                       #
#----------------------------------------------------------------------------#
AutoLoadPlugin {{ 'true' if collectd_conf.get('AutoLoadPlugin', False) else 'false' }}

#----------------------------------------------------------------------------#
# Interval at which to query values. This may be overwritten on a per-plugin #
# base by using the 'Interval' option of the LoadPlugin block:               #
#   <LoadPlugin foo>                                                         #
#       Interval 60                                                          #
#   </LoadPlugin>                                                            #
#----------------------------------------------------------------------------#
Interval {{ collectd_conf.get('Interval', 10) }}

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

<Plugin syslog>
  LogLevel info
</Plugin>

##############################################################################
# LoadPlugin section                                                         #
#----------------------------------------------------------------------------#
{% if p_aggregation %}
LoadPlugin aggregation
{% endif %}
#LoadPlugin amqp
#LoadPlugin apache
{% if 'apcups' in extra_plugin_config %}
LoadPlugin apcups
{% endif %}
#LoadPlugin aquaero
{% if p_ceph %}
LoadPlugin ceph
{% endif %}
LoadPlugin contextswitch
LoadPlugin conntrack
LoadPlugin cpu
{% if not virtual_machine and machine_type not in ('raspberrypi') %}
LoadPlugin cpufreq
LoadPlugin irq
LoadPlugin numa
LoadPlugin sensors
{% endif %}
#LoadPlugin csv
#LoadPlugin curl
#LoadPlugin curl_json
#LoadPlugin curl_xml
LoadPlugin df
LoadPlugin disk
LoadPlugin entropy
LoadPlugin ethstat
LoadPlugin exec
#LoadPlugin filecount
#LoadPlugin fscache
#LoadPlugin gmond
{% if "hddtemp" in extra_plugin_config %}
LoadPlugin hddtemp
{% endif %}
LoadPlugin interface
{% if "iptables" in extra_plugin_config %}
LoadPlugin iptables
{% endif %}
{% if "ipmi" in extra_plugin_config %}
LoadPlugin ipmi
{% endif %}
{% if False %}
#LoadPlugin ipvs
{% endif %}
{% if False %}
#LoadPlugin java
#LoadPlugin libvirt
{% endif %}
LoadPlugin load
#LoadPlugin lpar
#LoadPlugin lvm
#LoadPlugin madwifi
#LoadPlugin mbmon
{% if "md" in extra_plugin_config %}
LoadPlugin md
{% endif %}
{% if "memcached" in extra_plugin_config %}
LoadPlugin memcached
{% endif %}
LoadPlugin memory
#LoadPlugin modbus
#LoadPlugin multimeter
{% if p_mysql %}
LoadPlugin mysql
{% endif %}
#LoadPlugin netapp
#LoadPlugin netlink
{% if p_network -%}
LoadPlugin network
{% endif %}
{% if nfs_server %}
LoadPlugin nfs
{% endif %}
{% if "nginx" in extra_plugin_config %}
LoadPlugin nginx
{% endif %}
#LoadPlugin notify_desktop
#LoadPlugin notify_email
#LoadPlugin nut
#LoadPlugin olsrd
#LoadPlugin onewire
#LoadPlugin openvpn
#LoadPlugin oracle
{% if "perl" in extra_plugin_config %}
<LoadPlugin perl>
  Globals true
</LoadPlugin>
{% endif %}
#LoadPlugin pinba
# LoadPlugin ping
#LoadPlugin powerdns
LoadPlugin processes
#LoadPlugin protocols
#LoadPlugin redis
#LoadPlugin routeros
#LoadPlugin rrdcached
#LoadPlugin rrdtool
#LoadPlugin serial
#LoadPlugin sigrok
{% if "snmp" in extra_plugin_config %}
LoadPlugin snmp
{% endif %}
LoadPlugin statsd
#LoadPlugin swap
#LoadPlugin table
LoadPlugin tail
#LoadPlugin tail_csv
#LoadPlugin tape
#LoadPlugin ted
#LoadPlugin tokyotyrant
LoadPlugin unixsock
LoadPlugin uptime
LoadPlugin users
#LoadPlugin uuid
#LoadPlugin varnish
#LoadPlugin mic
LoadPlugin vmem
#LoadPlugin vserver
#LoadPlugin wireless
{% if p_write_graphite %}
LoadPlugin write_graphite
{% endif %}
#LoadPlugin write_http
#LoadPlugin write_mongodb
#LoadPlugin write_redis
{% if p_write_riemann %}
LoadPlugin write_riemann
{% endif %}
{% if "xencpu" in extra_plugin_config %}
LoadPlugin xencpu
{% endif %}
{% if "zookeeper" in extra_plugin_config %}
LoadPlugin zookeeper
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
{% if 'apcups' in extra_plugin_config %}
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
  MountPoint "/dev"
  MountPoint "/dev/shm"
  # FSType "cgroup_root"
  Device "root"
  Device "overlay"
  Device "cgroup_root"
  Device "shm"
  Device "devtmpfs"
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
{% if "hddtemp" in extra_plugin_config %}
<Plugin hddtemp>
  Host "127.0.0.1"
  Port "7634"
</Plugin>
{% endif %}

<Plugin interface>
  Interface "/^vif.+/"
  Interface "/^veth.+/"
  Interface "/^br.+/"
  IgnoreSelected true
</Plugin>

{% if "ipmi" in extra_plugin_config %}
<Plugin ipmi>
#	Sensor "some_sensor"
#	Sensor "another_one"
	IgnoreSelected true
	NotifySensorAdd false
	NotifySensorRemove true
	NotifySensorNotPresent false
</Plugin>
{% endif %}
{% if "iptables" in extra_plugin_config %}
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
{% if "md" in extra_plugin_config %}
<Plugin md>
  Device "/dev/md0"
  IgnoreSelected true
</Plugin>
{% endif %}
<Plugin memory>
  ValuesPercentage true
</Plugin>
{% if "memcached" in extra_plugin_config %}
<Plugin memcached>
	Host "::1"
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
{% if "nginx" in extra_plugin_config %}
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

{% if p_processes %}
<Plugin processes>
  {% for process in p_processes %}
  Process "{{ process }}" "{{ process }}"
  {% endfor %}
</Plugin>
{% endif %}

#<Plugin protocols>
#	Value "/^Tcp:/"
#	IgnoreSelected false
#</Plugin>

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

<Plugin statsd>
  Host "::"
  Port "8125"
  DeleteCounters true
  DeleteTimers   true
  DeleteGauges   true
  DeleteSets     true
  TimerPercentile 95.0
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
	SocketFile "/run/collectd-unixsock"
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
{% if "zookeeper" in extra_plugin_config %}
<Plugin "zookeeper">
   Host "::1"
   Port "2181"
</Plugin>
{% endif %}
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
