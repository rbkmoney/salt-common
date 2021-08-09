include=/etc/php/fpm-php{{ php_version }}/fpm.d/*.conf

[global]
; Pid file
; Default Value: none
; Warning: pid file is overriden by the Gentoo init script.
pid = /run/php-fpm.pid

; Error log file
; Note: the default prefix is /var/lib
; Default Value: log/php-fpm.log
error_log = /var/log/php-fpm.log

; Log level
; Possible Values: alert, error, warning, notice, debug
; Default Value: notice
log_level = notice

; If this number of child processes exit with SIGSEGV or SIGBUS within the time
; interval set by emergency_restart_interval then FPM will restart. A value
; of '0' means 'Off'.
; Default Value: 0
emergency_restart_threshold = 0

; Interval of time used by emergency_restart_interval to determine when
; a graceful restart will be initiated.  This can be useful to work around
; accidental corruptions in an accelerator's shared memory.
; Available Units: s(econds), m(inutes), h(ours), or d(ays)
; Default Unit: seconds
; Default Value: 0
emergency_restart_interval = 0

; Time limit for child processes to wait for a reaction on signals from master.
; Available units: s(econds), m(inutes), h(ours), or d(ays)
; Default Unit: seconds
; Default Value: 0
process_control_timeout = 0

; Send FPM to background. Set to 'no' to keep FPM in foreground for debugging.
; Default Value: yes
daemonize = yes
