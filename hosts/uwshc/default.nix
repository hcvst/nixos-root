# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  # HCVST --------------------------------------------------------------------

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  
  nix.settings.trusted-users = [ "nixos" ]; # required for devenv cache

  environment.localBinInPath = true;
  programs.bash = {
    enable = true;
    shellAliases = {
      lg = "lazygit";
      ls = "${pkgs.eza}/bin/eza";
      l = "${pkgs.eza}/bin/eza -lah --git";
      ll = "${pkgs.eza}/bin/eza -l";
      la = "${pkgs.eza}/bin/eza -a";
      lt = "${pkgs.eza}/bin/eza --tree";
      lla = "${pkgs.eza}/bin/eza -la";
      snrs = "sudo nixos-rebuild switch";
      hi = "echo Hello, $USER!";
    };
  };
  programs.autojump.enable = true;
  programs.direnv.enable = true;
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      user = {
        name = "hcvst";
	email = "hc@vst.io";
      };
    };
  };
  programs.lazygit.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    configure = {
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ zk-nvim ];
      };
      customLuaRC = ''
        require("zk").setup({
          picker = "fzf",
          lsp = {
            config = {
              name = "zk",
              cmd = { "zk", "lsp" },
              filetypes = { "markdown" },
            },
            auto_attach = {
              enabled = true,
            },
          },
        })
      '';
    };
  };
  programs.nix-ld.enable = true;
  programs.starship.enable = true;

  services.cron.enable = true;

  environment.systemPackages = with pkgs; [
    bat
    devenv
    eza
    fastfetch
    fzf
    gh
    glow
    helix
    lld
    mdcat
    tree
    wget
    zk
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
