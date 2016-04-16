module Confd =
       autoload xfm

       let lns = Shellvars.lns

       let filter = (incl "/etc/conf.d/*") . (excl "net") . (excl "net.*") . (excl "*~") . (excl ".*") . (excl "#*#") . (excl "*.bak")

       let xfm = transform lns filter
