{ pkgs, config, ... }:
{

  imports = [
    ../../common/optional/starship.nix
    ../../common/optional/xdg.nix
    ../../common/optional/zk.nix
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
    initContent = ''
      # pick a recent file and open in nvim
      v() {
        local file
        file=$(
          nvim --headless +'lua for _, f in ipairs(vim.v.oldfiles) do print(vim.fn.fnamemodify(f, ":p")) end' +q 2>&1 |
          tr -d '\r' |
          awk 'NF && !seen[$0]++' |
          while IFS= read -r f; do [[ -f "$f" ]] && echo "$f"; done |
          fzf --height 40% --reverse --preview 'bat --color=always --line-range=:50 {} 2>/dev/null || cat {}'
        )
        [[ -n "$file" ]] && nvim "$file"
      }
    '';
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
    plugins = with pkgs.vimPlugins; [
      telescope-nvim      # for interactive pickers
      plenary-nvim        # telescope dependency
      blink-cmp           # autocomplete for [[
    ];
    extraLuaConfig = ''
      vim.g.mapleader = "\\"
      vim.g.maplocalleader = "\\"

      vim.keymap.set("n", "<leader>v", "<Cmd>Telescope oldfiles<CR>")

      -- added to autocomplete links like [[note name]] in zk markdown files
      require("blink.cmp").setup({
        keymap = {
          preset = "default",
          ["<CR>"] = { "accept", "fallback" },
          ["<Tab>"] = { "select_next", "fallback" },
          ["<S-Tab>"] = { "select_prev", "fallback" },
        },
        sources = {
          default = { "lsp" }
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
