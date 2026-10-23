{ inputs, ... }:
{
  home.persistence."/persist" = {

    directories = [
      "Projects"
      "Documents"
      "Downloads"
      ".ssh"
      ".gnupg"
      ".config/gh"
      ".local/share/keyrings"
    ];

    files = [
      ".zsh_history"
     ];
  };
}
