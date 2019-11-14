## Managed by Salt
## JVM configuration

# Xms represents the initial size of total heap space
# Xmx represents the maximum size of total heap space
## See https://www.elastic.co/guide/en/elasticsearch/reference/current/heap-size.html

-Xms{{ heap_size }}
-Xmx{{ heap_size }}

## Expert settings
################################################################
##
## All settings below this section are considered
## expert settings. Don't tamper with them unless
## you understand what you are doing
##
################################################################

## GC configuration
{% if gc_type == 'G1C1' %}
-XX:+UseG1GC
-XX:G1ReservePercent=25
-XX:InitiatingHeapOccupancyPercent={{ gc_occupancy_value }}
-Xlog:gc*,gc+age=trace,safepoint:file=/var/log/elasticsearch/gc.log:utctime,pid,tags:filecount=10,filesize=64m
{% else %}
-XX:+UseConcMarkSweepGC
-XX:CMSInitiatingOccupancyFraction={{ gc_occupancy_value }}
-XX:+UseCMSInitiatingOccupancyOnly
{% endif %}
## optimizations

# pre-touch memory pages used by the JVM during initialization
-XX:+AlwaysPreTouch

## basic

# force the server VM
-server

# explicitly set the stack size
-Xss{{ stack_size }}

# set to headless, just in case
-Djava.awt.headless=true

# ensure UTF-8 encoding by default (e.g. filenames)
-Dfile.encoding=UTF-8

# use our provided JNA always versus the system one
-Djna.nosys=true

# turn off a JDK optimization that throws away stack traces for common
# exceptions because stack traces are important for debugging
-XX:-OmitStackTraceInFastThrow

# flags to configure Netty
-Dio.netty.noUnsafe=true
-Dio.netty.noKeySetOptimization=true
-Dio.netty.recycler.maxCapacityPerThread=0

# log4j 2
-Dlog4j.shutdownHookEnabled=false
-Dlog4j2.disable.jmx=true

{% for key, value in extra_options.items() %}
-{{ key }}{{ '='+value if value else '' }}
{% endfor %}
