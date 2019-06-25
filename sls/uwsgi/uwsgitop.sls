# TODO: перенести app-admin/uwsgitop в rbkmoney overlay
# TODO: кейворды в gpp
app-admin/uwsgitop:
  portage_config.flags:
    - accept_keywords:
      - ~*
  pkg.latest:
    - require:
      - portage_config: app-admin/uwsgitop
