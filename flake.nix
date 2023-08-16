{
  description = "zfs flake to run zfs-auto-snapshot during nixos-switch";
  outputs = { self, nixpkgs }: {
    nixosModules.permown = {
      imports = [ ./default.nix ];
    };
  };
}
