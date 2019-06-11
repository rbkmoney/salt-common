#!pyobjects
# -*- mode: python -*-

def process_target(package, version_num):
    if version_num is None:
        keyword, prefix = None, None
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
