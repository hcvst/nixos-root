{ inputs, ... }:
{
  home.persistence."/persist" = {

    directories = [
      "Projects"
      "Documents"
      "Downloads"
      "Zettelkasten"
      ".ssh"
      ".gnupg"
      ".config/gh"
      ".local/share/keyrings"
      ".local/share/fish" # fish history
    ];

    files = [
      ".config/pet/snippet.toml"
     ]; 
  };
}
