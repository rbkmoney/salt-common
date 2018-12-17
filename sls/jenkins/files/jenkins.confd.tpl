# Managed by Salt
# -*- mode: shell-script -*-
{% set conf = salt['pillar.get']('jenkins:confd', {}) %}
{% set heap_size = conf.get('heap-size', '512m') %}

JENKINS_USER=jenkins
# Directory where Jenkins store its configuration and working
# files (checkouts, build reports, artifacts, ...).
JENKINS_HOME="/var/lib/jenkins/home"
JENKINS_PIDFILE="/run/jenkins.pid"
JENKINS_WAR="/opt/jenkins/jenkins.war"
JENKINS_PORT="{{ conf.get('port', '8080') }}"
JENKINS_ENABLE_ACCESS_LOG="yes"
# Maximum number of HTTP worker threads.
JENKINS_HANDLER_MAX="{{ conf.get('handler-max', '100') }}"
# Maximum number of idle HTTP worker threads.
JENKINS_HANDLER_IDLE="{{ conf.get('handler-idle', '20') }}"
# Debug level for logs -- the higher the value, the more verbose.
# 5 is INFO.
JENKINS_DEBUG_LEVEL="{{ conf.get('debug-level', '5') }}"
# Options to pass to java when running Jenkins.
JENKINS_JAVA_OPTIONS="-Djava.awt.headless=true -Xms{{ heap_size }} -Xmx{{ heap_size }} {{ conf.get('java-extra-opts', '') }}"
# Pass arbitrary arguments to Jenkins.
# Full option list: java -jar jenkins.war --help
JENKINS_ARGS="{{ conf.get('jenkins-args', '--httpListenAddress=::1') }}"
