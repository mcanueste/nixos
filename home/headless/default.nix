{ pkgs, ... }:
{
  imports = [
    ./packages.nix
    ./tmux.nix
    ./bash.nix
    ./dircolors.nix
    ./git.nix
    ./exa.nix
    ./bat.nix
    ./fzf.nix
    ./zoxide.nix
  ];
}

