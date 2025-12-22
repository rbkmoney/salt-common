#!pyobjects
# -*- mode: python -*-
from os import path
from salt.utils import dictupdate
import yaml

class NoAliasDumper(yaml.SafeDumper):
    def ignore_aliases(self, data):
        return True

conf_path = "/etc/prometheus/"
pki_path = "/etc/pki/prometheus/"
log_path = "/var/log/prometheus/"
data_path = "/var/lib/prometheus/"

rule_path = path.join(conf_path, "rules.d") + "/"
prometheus_yml_path = path.join(conf_path, "prometheus.yml")
web_yml_path = path.join(conf_path, "web.yml")

g_init = grains("init", "none")
g_fqdn = grains("fqdn")
g_fqdn_ipv6 = grains("fqdn_ipv6")

p_prometheus = pillar("prometheus", {})
p_tls = p_prometheus.get("tls", {})
p_user = p_prometheus.get("user", "prometheus")
p_group = p_prometheus.get("group", "prometheus")

def render_dict_to_args(d, keypath=[]):
    strings = []
    for k, v in d.items():
        s = ""
        if isinstance(v, dict):
            kp = keypath.copy()
            kp.append(k)
            s += render_dict_to_args(v, kp)
        else:
            s += "--"
            if len(keypath) > 0:
                s += '.'.join(keypath) + '.'
            if isinstance(v, str):
                s += k + '=' + v
            elif v is True:
                s += k
            elif v is None:
                s += k
            elif isinstance(v, bool):
                # But not True
                s += k + '=' + str(v).lower()
        strings.append(s)
    return ' '.join(strings)
