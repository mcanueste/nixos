{
  pkgs,
  inputs,
  ...
}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Flakes settings
  nix.package = pkgs.nixVersions.unstable;
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.warn-dirty = false;

  # Optimise store
  nix.optimise.automatic = true;
  nix.settings.auto-optimise-store = true;

  # Automate garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  # Avoid unwanted garbage collection when using nix-direnv
  nix.settings.keep-outputs = true;
  nix.settings.keep-derivations = true;

  # Binary caches
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://cache.garnix.io"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  imports = [
    ./browsers.nix
    ./chat.nix
    ./desktop
    ./editors
    ./font.nix
    ./gaming.nix
    ./hardware
    ./locale.nix
    ./media.nix
    ./networking.nix
    ./packages.nix
    ./printer.nix
    ./security.nix
    ./sound.nix
    ./term
    ./tools
    ./user.nix
    ./virtualization.nix
  ];
}
