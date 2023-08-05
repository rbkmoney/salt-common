# -*- coding: utf-8 -*-

import os, subprocess, argparse, logging
try:
  from dns import resolver
  HAS_DNSPYTHON = True
except ImportError:
  HAS_DNSPYTHON = False

IPSET_CMD = '/usr/sbin/ipset'

log = logging.getLogger(__name__)

def __virtual__():
  '''Check module requirements'''
  if not HAS_DNSPYTHON:
    return (False, 'ipset_updater module cannot be loaded: dnspython not available')
  if not os.path.isfile(IPSET_CMD):
    return (False, 'ipset_updater module cannot be loaded: {0} does not exist'.format(IPSET_CMD))
  return 'ipset_updater'

def get_records(qnames, family):
  records = {}
  r = resolver.Resolver()
  for qname in qnames:
    records[qname] = []
    try:
      answer = r.query(qname, {'ipv4': 'A', 'ipv6': 'AAAA'}[family])
    except resolver.NXDOMAIN as e:
      log.error(repr(e))
      return []
    except:
      raise
    for a in answer:
      records[qname].append(a.to_text())
  return records

def ipset_create_ifnotexists(ipset_name, ipset_type, family):
  if __salt__['ipset.check_set'](ipset_name, family):
    log.debug("'%s' set already exists", ipset_name)
    return True
  __salt__['ipset.new_set'](ipset_name, ipset_type, family, comment=True)

def ipset_flush(ipset_name, family):
  log.info("Flushing ipset %s", ipset_name)
  ret = __salt__['ipset.flush'](ipset_name, family)
  if ret is 'Success': return True
  return ret

def ipset_test(ipset_name, ip_address, family):
  log.debug("Testing '%s' in set '%s'", ip_address, ipset_name)
  ret = __salt__['ipset.check'](ipset_name, ip_address, family)
  if ret is True:
    log.debug("'%s' is in set '%s'", ip_address, ipset_name)
  else:
    log.debug("'%s' is not in set '%s'", ip_address, ipset_name)
  return ret

def ipset_differ(ipset_name, records, family):
  log.debug("Comparing ipset '%s' and records", ipset_name)
  different = False
  ipsets = __salt__['ipset.list_sets'](family=family)
  for ipset in ipsets:
    if 'Name' in ipset and ipset['Name'] == ipset_name:
      log.debug("ipset '%s' found on machine'", ipset_name)
      if 'Number of entries' in ipset and ipset['Number of entries'] == str(len(records)):
        log.debug("Entries count are equal for ipset '%s'", ipset_name)
      else:
        log.debug("Entries count are differ for ipset '%s'", ipset_name)
        different = True
      for address in records:
        if not ipset_test(ipset_name, address, family):
          different = True
      if different:
        break
  if different:
    log.debug("ipset '%s' and records are different", ipset_name)
  else:
    log.debug("ipset '%s' and records are equal", ipset_name)
  return different

def ipset_add(ipset_name, ip_address, family, comment=None):
  kwargs = {}
  if comment:
    kwargs['comment'] = comment
  log.info("Adding '%s' to set '%s', comment '%s'", ip_address, ipset_name, comment)
  return __salt__['ipset.add'](ipset_name, ip_address, family, **kwargs)

def ipset_add_ifnotexits(ipset_name, ip_address, family, comment=None):
  ret = ipset_test(ipset_name, ip_address, family)
  if ret is True: return True
  ret = ipset_add(ipset_name, ip_address, family, comment)
  if ret is 'Success': return True
  return ret

def update_ipset(ipset_name, cqnames, family, flush=False, create_ifnotexists=False):
  records = {}
  all_addrs = []
  for comment, qnames in cqnames.items():
    records[comment] = []
    for addrs in get_records(qnames, family).values():
      records[comment].extend(addrs)
      all_addrs.extend(addrs)
  if create_ifnotexists:
    ipset_create_ifnotexists(ipset_name, 'hash:ip', family)
  if ipset_differ(ipset_name, all_addrs, family):
    if flush:
      ret = ipset_flush(ipset_name, family)
      if ret is not True:
        log.error("ipset.flush returned %s, exiting", ret)
        return False
    for comment, addrs in records.items():
      log.info("Adding records for '%s'", comment)
      for address in addrs:
        ret = ipset_add_ifnotexits(ipset_name, address, family, comment)
        if ret is not True:
          log.error("ipset.add returned %s, exiting", ret)
          return False
  return True
