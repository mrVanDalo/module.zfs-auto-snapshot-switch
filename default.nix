{ config, pkgs, lib, ... }:
with lib;
with lib.types;
let
  cfg = config.services.zfs.nixosSwitchAutoSnapshot;

  cfgZfs = config.boot.zfs;
  autosnapPkg = pkgs.zfstools.override {
    zfs = cfgZfs.package;
  };
  zfsAutoSnap = "${autosnapPkg}/bin/zfs-auto-snapshot";


in
{

  options.services.zfs.nixosSwitchAutoSnapshot = mkOption {
    enable = mkEnableOption "zfs auto snapshot during nixos switch";
    keep = mkOption {
        type = int;
        description = "how many snapshot should be kept";
    };
  };

  config = mkIf cfg.enable {
    system.activationScripts.autoSnapshotSwitch = ''
        # 1. test if we are in a switch or a boot
        #    - checken ob das multi-user target aktiv ist
        # run zfs-auto-snapshot
        ${zfsAutoSnap} --quiet \
            --syslog \
            --label=nixos_boot \
            ${optinalString (cfg.keep > 0) "--keep=${cfg.keep}"} \
            //
    '';
  };

}
