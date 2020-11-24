def elibc():
     import os.path
     # initialize a grains dictionary
     grains = {}

     # Some code for logic that sets grains like
     if os.path.exists("/lib/ld-musl-x86_64.so.1"):
       grains['elibc'] = 'musl'
     # Does not work on 17.1
     elif os.path.exists("/lib/libc.so.0"):
       grains['elibc'] = 'uclibc'
     else:
       grains['elibc'] = 'glibc'

     return grains
