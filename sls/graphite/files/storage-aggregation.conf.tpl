{% set aggregation = salt['pillar.get']('carbon:cache:storage:aggregation', {}) %}
# Managed by Salt
# Aggregation methods for whisper files. Entries are scanned in order,
# and first match wins. This file is scanned for changes every 60 seconds
#
#  [name]
#  pattern = <regex>
#  xFilesFactor = <float between 0 and 1>
#  aggregationMethod = <average|sum|last|max|min>
#
#  name: Arbitrary unique name for the rule
#  pattern: Regex pattern to match against the metric name
#  xFilesFactor: Ratio of valid data points required for aggregation to the next retention to occur
#  aggregationMethod: function to apply to data points for aggregation
#
{% for k,v in aggregation.items() %}
[{{ k }}]
pattern = {{ v['pattern'] }}
xFilesFactor = {{ v.get('xFilesFactor', '0.1') }}
aggregationMethod = {{ v['aggregationMethod'] }}
{% endfor %}
