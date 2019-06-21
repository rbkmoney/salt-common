#!pyobjects
# -*- mode: python -*-
from salt.ext import six
import re

def process_target(package, version_num):
    if version_num is None:
        return package
    else:
        # PCRE modified a bit compared to one from ebuild.py since here we don't support list of USE package_vars in verstr 
        match = re.match('^(~|-|\*)?([<>]?=?)?([^<>=\[\]]*)$', version_num)
        if match:
            keyword, prefix, verstr = match.groups()
            # If no prefix characters were supplied and verstr contains a version, use '='
            if len(verstr) > 0 and verstr[0] != ':':
                prefix = prefix or '='
                return '{0}{1}-{2}'.format(prefix, package, verstr)
            else:
                return '{0}{1}'.format(package, verstr)
        else:
            raise AttributeError(
                'Unable to parse version {0} of {1}'.\
                format(repr(version_num), package))

packages = pillar('gentoo:portage:packages', {})
for var in ('accept_keywords', 'use', 'mask'):
    result = []
    for cp, package_vars in packages.items():
        if var not in package_vars:
            continue
        value = package_vars[var] if isinstance(package_vars[var], six.string_types) else ' '.join(package_vars[var])
        verspec = cp if var == 'use' else process_target(cp, package_vars.get('version'))
        result.append((verspec, value))
    result_str = ''.join([ "{} {}\n".format(cp, value) for cp, value in result.sort(key=itemgetter(1)) ])
    filename = '/etc/portage/package.{}/SALT'.format(var)
    File.managed(filename, contents=result_str, mode='0640',
                 user='root', group='portage', makedirs=True)
