{% set schemas = salt['pillar.get']('carbon:cache:storage:schemas', {}) %}
# Managed by Salt
# Schema definitions for Whisper files. Entries are scanned in order,
# and first match wins. This file is scanned for changes every 60 seconds.
#
#  [name]
#  pattern = regex
#  retentions = timePerPoint:timeToStore, timePerPoint:timeToStore, ...

# Carbon's internal metrics. This entry should match what is specified in
# CARBON_METRIC_PREFIX and CARBON_METRIC_INTERVAL settings
{% for k,v in schemas.items() %}
[{{ k }}]
pattern = {{ v['pattern'] }}
priority = {{ v.get('priority', 1) }}
retentions = {{ v['retentions'] }}
{% endfor %}
