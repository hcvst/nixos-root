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
      ".local/share/fish" # fish history
    ];

    files = [ ]; # add as you discover needs
  };
}
