#!/usr/bin/env python3

from sys import argv
import subprocess
import datetime, time
import json
import re

timestamp = datetime.datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%S.%fZ')

args = argv[1:]
process = subprocess.Popen(args, stdout=subprocess.PIPE)
output = process.communicate()[0].decode('utf-8')

log = {
  '@timestamp': timestamp
}

if args[0] == 'clamscan':
  log['scan_summary'] = {}
  log['detections'] = []
  log['warnings'] = []

  for string in output.split('\n'):
    if ':' in string:
      if 'warning' in string.lower():
        log['warnings'].append(string)
      elif 'FOUND' in string:
        log['detections'].append(string)
      else:
        key, value = string.split(': ', maxsplit=1)
        log['scan_summary'][key.lower().replace(' ', '_')] = value

elif args[0] == 'freshclam':
  expr = re.compile(r'(?P<database>[a-z]+\.[a-z]+) (?P<status>[^\(]+) \(version: ' + 
    r'(?P<version>[0-9]+), sigs: (?P<sigs>[0-9]+), f-level: (?P<f_level>[0-9]+), builder: (?P<builder>[^,]+)\)')
  for m in expr.finditer(output):
    group = m.groupdict()
    database = group.pop('database')
    log[database] = group
  log['raw'] = output

print(json.dumps(log))
