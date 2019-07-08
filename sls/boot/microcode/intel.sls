# TODO: add microcode into kernel
sys-firmware/intel-microcode:
  pkg.latest

sys-apps/iucode_tool:
  pkg.latest

update_iucode:
  cmd.wait:
    - name: "iucode_tool -S --write-earlyfw=/boot/early_ucode.cpio /lib/firmware/intel-ucode/* --overwrite"
    - watch:
      - pkg: sys-firmware/intel-microcode
      - pkg: sys-apps/iucode_tool
