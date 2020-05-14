# -*- mode: conf -*-
# Managed by Salt
{% set conf = salt['pillar.get']('grafana:conf', {}) %}

app_mode = production
instance_name = {{ grains['fqdn'] }}

#################################### Paths ####################################
[paths]
data = /var/lib/grafana
logs = /var/log/grafana
plugins = /var/lib/grafana/plugins

#
#################################### Server ####################################
[server]
{% set server = conf['server'] %}
# Protocol (http, https, socket)
protocol = {{ server.get('protocol', 'http') }}
http_addr = {{ server.get('http-addr', '[::1]') }}
http_port = {{ server.get('http-port', '3023') }}

# The full public facing url you use in browser, used for redirects and emails
# If you use reverse proxy and sub path specify full url (with sub path)
root_url = {{ server['root-url'] }}

# Redirect to correct domain if host header does not match domain
# Prevents DNS rebinding attacks
enforce_domain = {{ server.get('enforce-domain', 'false') }}

# Log web requests
router_logging = {{ server.get('router-logging', 'false') }}

# the path relative working path
;static_root_path = public

# enable gzip
enable_gzip = false

#################################### Database ####################################
[database]
{% set db = conf['db'] %}
# Use either URL or the previous fields to configure the database
# Example: mysql://user:secret@host:port/database
url = {{ db.engine }}://{{ db.user }}:{{ db.password }}@{{ db.host }}:{{ db.port }}/{{ db.name }}


# Max idle conn setting default is 2
max_idle_conn = {{ db.get('max-idle-conn', 2) }}

# Max conn setting default is 0 (mean not set)
max_open_conn = {{ db.get('max-open-conn', 0) }}


#################################### Session ####################################
[session]
{% set session = conf['session'] %}
# Either "memory", "file", "redis", "mysql", "postgres", default is "file"
provider = {{ session['provider'] }}

# Provider config options
# memory: not have any config yet
# file: session dir path, is relative to grafana data_path
# redis: config like redis server e.g. `addr=127.0.0.1:6379,pool_size=100,db=grafana`
# mysql: go-sql-driver/mysql dsn config string, e.g. `user:password@tcp(127.0.0.1:3306)/database_name`
# postgres: user=a password=b host=localhost port=5432 dbname=c sslmode=disable
provider_config = {{ db.engine }}://{{ db.user }}:{{ db.password }}@tcp({{ db.host }}:{{ db.port }})/{{ db.name }}

# Session cookie name
cookie_name = {{ session.get('cookie-name', 'grafana_sess') }}

# If you use session in https only, default is false
cookie_secure = {{ session.get('cookie-secure', 'false') }}

# Session life time, default is 86400
session_life_time = {{ session.get('life-time', 86400) }}

#################################### Data proxy ###########################
[dataproxy]
{% set dataproxy = conf.get('dataproxy', {}) %}
# This enables data proxy logging, default is false
logging = {{ dataproxy.get('logging', 'false') }}


#################################### Analytics ####################################
[analytics]
# Server reporting, sends usage counters to stats.grafana.org every 24 hours.
# No ip addresses are being tracked, only simple counters to track
# running instances, dashboard and error counts. It is very helpful to us.
# Change this option to false to disable reporting.
reporting_enabled = false

# Set to false to disable all checks to https://grafana.net
# for new vesions (grafana itself and plugins), check is used
# in some UI views to notify that grafana or plugin update exists
# This option does not cause any auto updates, nor send any information
# only a GET request to http://grafana.com to get latest versions
check_for_updates = false

# Google Analytics universal tracking code, only enabled if you specify an id here
;google_analytics_ua_id =

#################################### Security ####################################
[security]
{% set security = conf['security'] %}
# default admin user, created on startup
admin_user = {{ security.get('admin-user', 'admin') }}

# default admin password, can be changed before first start of grafana,  or in profile settings
admin_password = {{ security['admin-password'] }}

# used for signing
secret_key = {{ security['secret-key'] }}

# disable gravatar profile images
disable_gravatar = true

[snapshots]
# snapshot sharing options
;external_enabled = true
;external_snapshot_url = https://snapshots-origin.raintank.io
;external_snapshot_name = Publish to snapshot.raintank.io

# remove expired snapshot
;snapshot_remove_expired = true

# remove snapshots after 90 days
;snapshot_TTL_days = 90

#################################### Users ####################################
[users]
{% set users = conf.get('users', {}) %}
# disable user signup / registration
allow_sign_up = {{ 'true' if users.get('allow-sign-up', False) else 'false' }}

# Allow non admin users to create organizations
allow_org_create = {{ 'true' if users.get('allow-org-create', False) else 'false' }}

# Set to true to automatically assign new users to the default organization (id 1)
auto_assign_org = {{ 'true' if users.get('auto-assign-org', True) else 'false' }}
auto_assign_org_id = {{ users.get('auto-assign-org-id', 1) }}

# Default role new users will be automatically assigned (if disabled above is set to true)
auto_assign_org_role = {{ users.get('auto-assign-org-role', 'Viewer') }}

# Background text for the user field on the login page
login_hint = {{ users.get('login-hint', 'email or username') }}

# Default UI theme ("dark" or "light")
default_theme = {{ users.get('default-theme', 'dark') }}

# External user management, these options affect the organization users view
;external_manage_link_url =
;external_manage_link_name =
;external_manage_info =

[auth]
# Set to true to disable (hide) the login form, useful if you use OAuth, defaults to false
disable_login_form = true

# Set to true to disable the signout link in the side menu. useful if you use auth.proxy, defaults to false
disable_signout_menu = true

[auth.proxy]
enabled = true
header_name = REMOTE_USER
;header_property = username
auto_sign_up = true
;whitelist = 192.168.1.1, 192.168.2.1

#################################### SMTP / Emailing ##########################
[smtp]
;enabled = false
;host = localhost:25
;user =
# If the password contains # or ; you have to wrap it with trippel quotes. Ex """#password;"""
;password =
;cert_file =
;key_file =
;skip_verify = false
;from_address = admin@grafana.localhost
;from_name = Grafana
# EHLO identity in SMTP dialog (defaults to instance_name)
;ehlo_identity = dashboard.example.com

[emails]
welcome_email_on_sign_up = false

#################################### Logging ##########################
[log]
{% set log = conf.get('log', {}) %}
# Either "console", "file", "syslog". Default is console and  file
# Use space to separate multiple modes, e.g. "console file"
mode = {{ log.get('mode', 'file') }}

# Either "debug", "info", "warn", "error", "critical", default is "info"
level = {{ log.get('level', 'info') }}

{% if 'filters' in log %}
# optional settings to set different levels for specific loggers. Ex filters = sqlstore:debug
filters = {{ log['filters'] }}
{% endif %}

# For "console" mode only
[log.console]
;level =

# log line format, valid options are text, console and json
;format = console

# For "file" mode only
[log.file]
;level =

# log line format, valid options are text, console and json
format = json

# This enables automated log rotate(switch of following options), default is true
;log_rotate = true

# Max line number of single file, default is 1000000
;max_lines = 1000000

# Max size shift of single file, default is 28 means 1 << 28, 256MB
;max_size_shift = 28

# Segment log daily, default is true
;daily_rotate = true

# Expired days of log file(delete after max days), default is 7
;max_days = 7

[log.syslog]
;level =

# log line format, valid options are text, console and json
;format = text

# Syslog network type and address. This can be udp, tcp, or unix. If left blank, the default unix endpoints will be used.
;network =
;address =

# Syslog facility. user, daemon and local0 through local7 are valid.
;facility =

# Syslog tag. By default, the process' argv[0] is used.
;tag =


;#################################### Dashboard JSON files ##########################
[dashboards.json]
enabled = true
path = /var/lib/grafana/dashboards

#################################### Alerting ############################
[alerting]
# Disable alerting engine & UI features
enabled = true
# Makes it possible to turn off alert rule execution but alerting UI is visible
execute_alerts = true

#################################### Internal Grafana Metrics ##########################
# Metrics available at HTTP API Url /api/metrics
[metrics]
# Disable / Enable internal metrics
enabled = true

# Publish interval
interval_seconds  = 10

# Send internal metrics to Graphite
[metrics.graphite]
# Enable by setting the address setting (ex localhost:2003)
;address =
;prefix = prod.grafana.%(instance_name)s.

#################################### Distributed tracing ############
[tracing.jaeger]
# Enable by setting the address sending traces to jaeger (ex localhost:6831)
;address = localhost:6831
# Tag that will always be included in when creating new spans. ex (tag1:value1,tag2:value2)
;always_included_tag = tag1:value1
# Type specifies the type of the sampler: const, probabilistic, rateLimiting, or remote
;sampler_type = const
# jaeger samplerconfig param
# for "const" sampler, 0 or 1 for always false/true respectively
# for "probabilistic" sampler, a probability between 0 and 1
# for "rateLimiting" sampler, the number of spans per second
# for "remote" sampler, param is the same as for "probabilistic"
# and indicates the initial sampling rate before the actual one
# is received from the mothership
;sampler_param = 1

#################################### Grafana.com integration  ##########################
# Url used to to import dashboards directly from Grafana.com
[grafana_com]
;url = https://grafana.com

#################################### External image storage ##########################
[external_image_storage]
# Used for uploading images to public servers so they can be included in slack/email messages.
# you can choose between (s3, webdav, gcs)
;provider =

[external_image_storage.s3]
;bucket =
;region =
;path =
;access_key =
;secret_key =

[external_image_storage.webdav]
;url =
;public_url =
;username =
;password =

[external_image_storage.gcs]
;key_file =
;bucket =
