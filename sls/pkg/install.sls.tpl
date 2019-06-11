 #!jinja|pyobjects
# -*- mode: python -*-
#from salt://pkg/common.sls import process_target

packages_root = "gentoo:portage:packages"
package_params = pillar(packages_root + ":{{ package_name }}")
version = package_params.get('version', None)
pkgs = {"{{ package_name }}": version} if version else ["{{ package_name }}"]
portage_config_params = { k: v for k: v in package_params.items() if k in ('use', 'mask', 'accept_keywords') }

PortageConfig.flags("{{ package_name }}", **portage_config_params)
Pkg.installed("{{ package_name }}", pkgs=pkgs, watch=PortageConfig("{{ package_name }}"))
