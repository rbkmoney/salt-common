# -*- mode: yaml -*-
{% set saltversion ='2015.8.12'%}
{% set hashdict = {
'2015.8.8': {'pkg.py': 'sha256=c53d39402dc874bb4f988ee2f538f375cf522dea2295a2ce5000b63ec6f410de',
             'ebuild.py': 'sha256=d7312d8c6e65eaf366c03f1d807170d64dac143988a35fbb0c53ab8ed82e3e5f'},
'2015.8.11': {'pkg.py': 'sha256=b4675a4117788315afe3f24d41b3a427958949b2fe72aeeb4bf28cc9eff34145',
              'ebuild.py': 'sha256=dba44f7f4c6996947b4312ffcb74993f0c54592dfc9759e28397253382fd2764'},
'2015.8.12': {'pkg.py': 'sha256=64d5c22cb246a5f057d105ec77b7d3539d9fae4aad6d65438125e84aa9a12397',
              'ebuild.py': 'sha256=913b88086a5b6fc4a51e1ea31c8455b26820e7e2f9e30976b5f83747e4d2e6be'},
}%}
/usr/lib/python2.7/site-packages/salt/states/pkg.py:
  file.patch:
    - source: salt://salt/files/salt-{{ saltversion }}-pkg.patch
    - hash: {{ hashdict[saltversion]['pkg.py'] }}

/usr/lib/python2.7/site-packages/salt/modules/ebuild.py:
  file.patch:
    - source: salt://salt/files/salt-{{ saltversion }}-ebuild.patch
    - hash: {{ hashdict[saltversion]['ebuild.py'] }}
