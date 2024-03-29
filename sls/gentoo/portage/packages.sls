#!pyobjects
# -*- mode: python -*-
# To require this state in your state:
# - require:
#     - file: gentoo.portage.packages
import re

def process_target(package, version_num):
    if version_num is None:
        return package
    else:
        # PCRE modified a bit compared to one from ebuild.py, since here we don't support
        # list of use flags or keywords in verstr 
        match = re.match('^([<>]?=?)?([^<>=\[\]]*)$', version_num)
        if match:
            prefix, verstr = match.groups()
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

def generate_result(packages, flag, _recurse=False):
    result = []
    for cp, package_vars in packages.items():
        if _recurse:
            atom = cp
            value = package_vars
        else:
            if flag not in package_vars:
                continue
            value = package_vars[flag]
            atom = process_target(cp, packages.get(cp, {}).get('version'))
        if value is True:
            result.append((atom, ''))
        elif value is False:
            pass
        elif type(value) == list:
            if flag == 'use':
                result.append((cp, ' '.join(value)))
            else:
                result.append((atom, ' '.join(value)))
        elif isinstance(value, dict):
            result.extend(generate_result(value, flag, True))
        else:
            if flag == 'use':
                result.append((cp, value))
            else:
                result.append((atom, value))
    return result

include('gentoo.portage.base-dirs')

packages = pillar('gentoo:portage:packages', {})
profile = pillar('gentoo:portage:profile', {})
clean_flags = pillar('gentoo:portage:clean-flags', True)
clean_profile = pillar('gentoo:portage:clean-profile', False)
clean_exclude_pat = pillar('gentoo:portage:clean-exclude-pat', 'SALT')
filenames = []

for var in ('accept_keywords', 'mask', 'unmask', 'use', 'env', 'license', 'properties'):
    d = '/etc/portage/package.{}/'.format(var)
    File.directory(d, create=True, mode='0755', user='root', group='portage',
                   clean=clean_flags, exclude_pat=clean_exclude_pat)

    result = generate_result(packages, var)
    result_str = '\n'.join(["{} {}".format(atom, value) for atom, value in sorted(result)])
    filename = d + 'SALT'
    filenames.append({'file': filename})
    File.managed(filename, contents=result_str+'\n', mode='0640',
                 user='root', group='portage', require=[File(d)])

for var in ('accept_keywords', 'mask', 'unmask', 'use', 'use.mask', 'use.force', 'provided'):
    d = '/etc/portage/profile/package.{}/'.format(var)
    File.directory(d, create=True, mode='0755', user='root', group='portage',
                   clean=clean_profile, exclude_pat=clean_exclude_pat,
                   require=[File('/etc/portage/profile/')])

    result = generate_result(profile, var)
    result_str = '\n'.join(["{} {}".format(atom, value) for atom, value in sorted(result)])
    filename = '/etc/portage/profile/package.{}/SALT'.format(var)
    filenames.append({'file': filename})
    File.managed(filename, contents=result_str, mode='0640',
                 user='root', group='portage', makedirs=True,
                 require=[File(d)])

File.managed('gentoo.portage.packages', name='/etc/portage/.gentoo.portage.packages', mode='0640',
             user='root', group='portage', contents="Stub file for convenient usage of gentoo.portage.packages state\n", require=filenames)
