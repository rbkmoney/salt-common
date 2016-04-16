module Makeconf =
       autoload xfm

       let lns = Shellvars.lns

       let filter = (incl "/etc/make.conf") . (incl "/etc/portage/make.conf")

       let xfm = transform lns filter
