{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "fetchkeys";
  runtimeInputs = with pkgs; [ openssh ssh-to-age ];
  text = ''
    target="''${1:-}"

    if [ -z "$target" ]; then
      echo "Usage: fetchkeys <host>"
      echo "       fetchkeys <user>@<host>"
      echo ""
      echo "Examples:"
      echo "  fetchkeys sunce          # host key only"
      echo "  fetchkeys hcvst@sunce    # host key + hcvst's user key"
      exit 1
    fi

    if [[ "$target" == *@* ]]; then
      user="''${target%@*}"
      host="''${target#*@}"
    else
      user=""
      host="$target"
    fi

    echo "=== Derived age key for host $host ==="
    host_key=$(ssh-keyscan -t ed25519 "$host" 2>/dev/null | ssh-to-age)
    if [ -z "$host_key" ]; then
      echo "(failed to fetch — is $host reachable on port 22?)"
      exit 1
    fi
    echo "$host_key"
    echo ""

    user_key=""
    if [ -n "$user" ]; then
      echo "=== Derived age key for user $user@$host ==="
      raw=$(ssh "$user@$host" 'cat ~/.ssh/id_ed25519.pub 2>/dev/null || echo NO_KEY')
      if [ "$raw" = "NO_KEY" ] || [ -z "$raw" ]; then
        echo "(no ~/.ssh/id_ed25519 yet — generate it first)"
      else
        user_key=$(echo "$raw" | ssh-to-age)
        echo "$user_key"
      fi
      echo ""
    fi

    echo "Add to .sops.yaml as anchors:"
    echo "  - &host_$host $host_key"
    [ -n "$user_key" ] && echo "  - &''${user}_''${host} $user_key"
  '';
}
