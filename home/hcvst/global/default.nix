{ pkgs, config, ... }:
{

  imports = [
    ../../common/optional/starship.nix
    ../../common/optional/xdg.nix
  ];

  home.username = "hcvst";
  home.homeDirectory = "/home/${config.home.username}";
  home.stateVersion = "25.11";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      lg = "lazygit";
      ls = "${pkgs.eza}/bin/eza";
      l = "${pkgs.eza}/bin/eza -lah --git";
      ll = "${pkgs.eza}/bin/eza -l";
      lrt = "${pkgs.eza}/bin/eza -l -snew";
      la = "${pkgs.eza}/bin/eza -a";
      lt = "${pkgs.eza}/bin/eza --tree";
      lla = "${pkgs.eza}/bin/eza -la";
      nhos = "${pkgs.nh}/bin/nh os switch";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user.name = config.home.username;
      user.email = "hc@vst.io";
    };
  };

  programs.lazygit.enable = true;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [ zk-nvim ];
    extraLuaConfig = ''
      require("zk").setup({
        picker = "fzf",
        lsp = {
          config = {
            name = "zk",
            cmd = { "zk", "lsp" },
            filetypes = { "markdown" },
          },
          auto_attach = { enabled = true },
        },
      })
    '';
  };

  home.packages = with pkgs; [
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
    nixfmt-rfc-style
    tree
    wget
    zk
    nixos-anywhere
  ];
}
