{ pkgs, lib, ... }:

let
  modifier = "Mod4";
in
{
  xsession.windowManager.i3 = {
    enable = true;

    config = {
      modifier = modifier;
      terminal = "${pkgs.alacritty}/bin/alacritty";

      fonts = {
        names = [ "misc-fixed" ];
        style = "medium-r-normal";
        size = 10.0;
      };

      keybindings = lib.mkOptionDefault {
        # launcher
        "${modifier}+d"       = "exec ${pkgs.rofi}/bin/rofi -show drun -show-icons";
        "${modifier}+Shift+s" = "exec ${pkgs.rofi}/bin/rofi -show ssh -show-icons";

        # kill
        "${modifier}+Shift+q" = "kill";

        # focus (hjkl)
        "${modifier}+j"         = "focus left";
        "${modifier}+k"         = "focus down";
        "${modifier}+l"         = "focus up";
        "${modifier}+semicolon" = "focus right";

        # move (hjkl)
        "${modifier}+Shift+J"         = "move left";
        "${modifier}+Shift+K"         = "move down";
        "${modifier}+Shift+L"         = "move up";
        "${modifier}+Shift+colon"     = "move right";

        # split
        "${modifier}+h" = "split h";
        "${modifier}+v" = "split v";

        # fullscreen
        "${modifier}+f" = "fullscreen toggle";

        # layout
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout default";

        # floating
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+space"       = "focus mode_toggle";

        # parent focus
        "${modifier}+a" = "focus parent";

        # workspaces 1-10
        "${modifier}+1" = "workspace 1";
        "${modifier}+2" = "workspace 2";
        "${modifier}+3" = "workspace 3";
        "${modifier}+4" = "workspace 4";
        "${modifier}+5" = "workspace 5";
        "${modifier}+6" = "workspace 6";
        "${modifier}+7" = "workspace 7";
        "${modifier}+8" = "workspace 8";
        "${modifier}+9" = "workspace 9";
        "${modifier}+0" = "workspace 10";

        # workspaces 11-13
        "${modifier}+i" = "workspace 11";
        "${modifier}+o" = "workspace 12";
        "${modifier}+p" = "workspace 13";

        # move to workspace 1-10
        "${modifier}+Shift+exclam"      = "move container to workspace 1";
        "${modifier}+Shift+at"          = "move container to workspace 2";
        "${modifier}+Shift+numbersign"  = "move container to workspace 3";
        "${modifier}+Shift+dollar"      = "move container to workspace 4";
        "${modifier}+Shift+percent"     = "move container to workspace 5";
        "${modifier}+Shift+asciicircum" = "move container to workspace 6";
        "${modifier}+Shift+ampersand"   = "move container to workspace 7";
        "${modifier}+Shift+asterisk"    = "move container to workspace 8";
        "${modifier}+Shift+parenleft"   = "move container to workspace 9";
        "${modifier}+Shift+parenright"  = "move container to workspace 10";

        # move to workspace 11-13
        "${modifier}+Shift+i" = "move container to workspace 11";
        "${modifier}+Shift+o" = "move container to workspace 12";
        "${modifier}+Shift+p" = "move container to workspace 13";

        # i3 control
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+r" = "restart";
        "${modifier}+Shift+e" = "exit";

        # lock
        "${modifier}+Control+l" = "exec ${pkgs.i3lock}/bin/i3lock -c 000000";

        # resize mode
        "${modifier}+r" = "mode resize";

        # system mode
        "${modifier}+Escape" = "mode \"$mode_system\"";

        # scratchpad
        "${modifier}+Shift+minus" = "move scratchpad";
        "${modifier}+minus"       = "scratchpad show";

        # media keys
        "XF86AudioMute"        = "exec ${pkgs.alsa-utils}/bin/amixer sset 'Master' toggle && pkill -RTMIN+10 i3blocks";
        "XF86AudioLowerVolume" = "exec ${pkgs.alsa-utils}/bin/amixer sset 'Master' 5%- && pkill -RTMIN+10 i3blocks";
        "XF86AudioRaiseVolume" = "exec ${pkgs.alsa-utils}/bin/amixer sset 'Master' 5%+ && pkill -RTMIN+10 i3blocks";
        "XF86AudioPlay"        = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioPause"       = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioNext"        = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPrev"        = "exec ${pkgs.playerctl}/bin/playerctl previous";
      };

      modes = {
        resize = {
          j         = "resize shrink width 10 px or 10 ppt";
          k         = "resize grow height 10 px or 10 ppt";
          l         = "resize shrink height 10 px or 10 ppt";
          semicolon = "resize grow width 10 px or 10 ppt";
          Left      = "resize shrink width 10 px or 10 ppt";
          Down      = "resize grow height 10 px or 10 ppt";
          Up        = "resize shrink height 10 px or 10 ppt";
          Right     = "resize grow width 10 px or 10 ppt";
          Return    = "mode default";
          Escape    = "mode default";
        };
      };

      bars = [
        {
          statusCommand = "${pkgs.i3blocks}/bin/i3blocks -c $HOME/.config/i3blocks/config";
          colors = {
            separator        = "#859900";
            background       = "#002b36";
            statusline       = "#268bd2";
            focusedWorkspace = { border = "#fdf6e3"; background = "#BB031F"; text = "#fdf6e3"; };
            activeWorkspace  = { border = "#fdf6e3"; background = "#FB610B"; text = "#fdf6e3"; };
            inactiveWorkspace = { border = "#586e75"; background = "#93a1a1"; text = "#002b36"; };
            urgentWorkspace  = { border = "#d33682"; background = "#FFD766"; text = "#002b36"; };
          };
        }
      ];

      startup = [
        { command = "${pkgs.nitrogen}/bin/nitrogen --restore"; notification = false; }
        { command = "nm-applet"; notification = false; }
      ];

      window.border = 0;

      gaps = {
        inner = 15;
        outer = 0;
        smartGaps = true;
      };
    };

    # anything the structured module doesn't cover
    extraConfig = ''
      set $mode_system (l) lock  (e) logout  (s) suspend  (r) reboot  (Shift+s) shutdown
      mode "$mode_system" {
          bindsym l       exec --no-startup-id ${pkgs.i3lock}/bin/i3lock -c 000000, mode "default"
          bindsym e       exec --no-startup-id i3-msg exit,                          mode "default"
          bindsym s       exec --no-startup-id systemctl suspend,                    mode "default"
          bindsym r       exec --no-startup-id systemctl reboot,                     mode "default"
          bindsym Shift+s exec --no-startup-id systemctl poweroff,                   mode "default"
          bindsym Return mode "default"
          bindsym Escape mode "default"
      }
    '';
  };

  xdg.configFile."i3blocks/config".source = ./i3blocks.conf;

  home.packages = with pkgs; [
    i3blocks
    i3lock
    rofi
    nitrogen
    alacritty
    playerctl
    alsa-utils
    xclip
    xorg.xrandr
  ];

  services.picom = {
    enable = true;
    fade = false;
    shadow = false;
    backend = "xrender";
  };
}