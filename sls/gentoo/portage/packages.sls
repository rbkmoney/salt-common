#!jinja|pyobjects
# -*- mode: python -*-
from salt.ext import six

def process_target(package, version_num):
    if version_num is None:
        return package
    else:
        # PCRE modified a bit compared to one from ebuild.py since here we don't support list of USE flags in verstr 
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
for packagefile in ('accept_keywords','use'):
    filedata = []
    for cp in packages:
        if packagefile not in cp:
            continue
        value = cp[packagefile] if isinstance(cp[packagefile], six.string_types) else " ".join(cp[packagefile])
        verspec = cp if packagefile == 'use' else process_target(cp)
        filedata.append((verspec, value))
    filedata_str = ''.join([ "{} {}\n".format(cp, value) for cp, value in filedata ])
    filename = "/etc/portage/package.{}/SALT".format(packagefile)
    File.managed(filename, contents=filedata_str, mode="0640",
                 user=root, group=portage, makedirs=True)
