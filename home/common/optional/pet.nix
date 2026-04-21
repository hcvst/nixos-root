{ pkgs, config, lib, ... }:
{

  home.packages = with pkgs; [
    pet
  ];

  programs.zsh.initContent = lib.mkBefore ''
    pets(){
      print -z $(pet search $*)
    }
  '';

  home.activation.createPetSnippetFile = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.home.homeDirectory}/.config/pet"
    touch "${config.home.homeDirectory}/.config/pet/snippet.toml"
  '';

  sops = {
    secrets."${config.home.username}/pet/token" = { };
    secrets."${config.home.username}/pet/gist-id" = { };

    templates."pet-config" = {
      path = "${config.home.homeDirectory}/.config/pet/config.toml";
      content = ''
        [General]
          snippetfile = "${config.home.homeDirectory}/.config/pet/snippet.toml"
          editor = "vim"
          column = 40
          selectcmd = "fzf"
          backend = "gist"
          sortby = ""
        [Gist]
          file_name = "pet-snippet.toml"
          access_token = "${config.sops.placeholder."${config.home.username}/pet/token"}"
          gist_id = "${config.sops.placeholder."${config.home.username}/pet/gist-id"}"
          public = false
          auto_sync = true
      '';
    };
  };
}
