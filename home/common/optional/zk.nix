# home/hcvst/features/zk.nix
{ pkgs, config, ... }:
{
  programs.zk = {
    enable = true;
    settings = {
      note = {
        language = "en";
        default-title = "Untitled";
        filename = "{{format-date now '%Y%m%d'}}-{{slug title}}";
        extension = "md";
        template = "default.md";
        id-charset = "alphanum";
        id-length = 4;
        id-case = "lower";
      };

      format.markdown = {
        hashtags = true;
        multiword-tags = false;
        colon-tags = false;
      };

      tool = {
        editor = "nvim";
        shell = "zsh";
        pager = "less -FIRX";
        fzf-preview = "bat -p --color always --language markdown {-1}";
      };

      group.daily = {
        paths = [ "journal" ];
        note = {
          filename = "{{format-date now '%Y-%m-%d'}}";
          template = "daily.md";
        };
      };

      alias = {
        journal = ''zk new --no-input "journal" --title "{{format-date now}}" $@'';
        recent = "zk edit --sort modified- --limit 10";
        orphans = "zk list --orphan";
        untagged = "zk list --tagless";
      };
    };
  };

  home.sessionVariables = {
    ZK_NOTEBOOK_DIR = "${config.home.homeDirectory}/Zettelkasten";
  };

  xdg.configFile = {
    "zk/templates/default.md".text = ''
      ---
      title: {{title}}
      date: {{format-date now}}
      tags: []
      ---

      # {{title}}

    '';

    "zk/templates/daily.md".text = ''
      ---
      title: {{format-date now "timestamp"}}
      date: {{format-date now}}
      tags: [daily]
      ---

      # {{format-date now "full"}}
      ## Todo
      - 

      ## Notes

    '';
  };

  # neovim with zk-nvim plugin and LSP
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      zk-nvim
    ];
    extraLuaConfig = ''
      vim.opt.conceallevel = 2
      vim.opt.concealcursor = "" 

      require("zk").setup({
        picker = "telescope",
        lsp = {
          config = {
            name = "zk",
            cmd = { "zk", "lsp" },
            filetypes = { "markdown" },
          },
          auto_attach = { enabled = true },
        },
      })

      -- open notes picker (most-used action)
      vim.keymap.set("n", "<leader>zke", "<Cmd>ZkNotes<CR>")

      -- new note with selection as title, replace with link
      -- (this is the one that makes linking effortless)
      vim.keymap.set("v", "<leader>zkn", ":'<,'>ZkNewFromTitleSelection<CR>")

      -- LspAttach block
      vim.keymap.set("n", "]l", function()
        vim.fn.search("\\v\\]\\(", "W")
      end, opts)

      vim.keymap.set("n", "[l", function()
        vim.fn.search("\\v\\]\\(", "bW")
      end, opts)
    '';
  };

  xdg.configFile."nvim/ftplugin/markdown.lua".text = ''
    -- only apply these mappings inside zk notebooks
    if require("zk.util").notebook_root(vim.fn.expand('%:p')) ~= nil then
      local function map(...) vim.api.nvim_buf_set_keymap(0, ...) end
      local opts = { noremap = true, silent = false }

      -- Enter follows the link under cursor
      map("n", "<CR>", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)

      -- preview linked note in floating window
      map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)

      -- backlinks / forward links
      map("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", opts)
      map("n", "<leader>zl", "<Cmd>ZkLinks<CR>", opts)
    end
  '';

  xdg.configFile."nvim/after/syntax/markdown.vim".text = ''
    syn region markdownWikiLink matchgroup=markdownLinkDelimiter start="\[\[" end="\]\]" contains=markdownUrl keepend oneline concealends
    syn region markdownLinkText matchgroup=markdownLinkTextDelimiter start="!\=\[\%(\%(\_[^][]\|\[\_[^][]*\]\)*]\%( \=[[(]\)\)\@=" end="\]\%( \=[[(]\)\@=" nextgroup=markdownLink,markdownId skipwhite contains=@markdownInline,markdownLineStart concealends
    syn region markdownLink matchgroup=markdownLinkDelimiter start="(" end=")" contains=markdownUrl keepend contained conceal
  '';

  # zsh helper functions
  programs.zsh.initContent = ''
    # edit notes interactively
    zke() { zk edit --interactive "$@"; }

    # new note with title from args
    zkn() { zk new --title "$*"; }

    # read a note rendered
    zkr() {
      local note=$(zk list --format path --quiet --interactive)
      [[ -n "$note" ]] && glow -p "$note"
    }

    # quick daily journal
    zkj() { zk journal; }

    # cd into notebook
    zkcd() { cd "$ZK_NOTEBOOK_DIR"; }
  '';

  
  home.packages = with pkgs; [
    glow   # rendered markdown viewer
    bat   
  ];
}
