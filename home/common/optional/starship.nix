{ ... }:
{
  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = builtins.fromTOML ''
      "$schema" = 'https://starship.rs/config-schema.json'

      format = """
      [](color_orange)\
      $os\
      $username\
      $hostname\
      [](bg:color_yellow fg:color_orange)\
      $directory\
      [](fg:color_yellow bg:color_aqua)\
      $git_branch\
      $git_status\
      [](fg:color_aqua bg:color_blue)\
      $c\
      $cpp\
      $rust\
      $golang\
      $nodejs\
      $php\
      $java\
      $kotlin\
      $haskell\
      $python\
      [](fg:color_blue bg:color_bg3)\
      $docker_context\
      $conda\
      $pixi\
      [](fg:color_bg3 bg:color_bg1)\
      $time\
      [ ](fg:color_bg1)\
      $line_break$character"""

      palette = 'gruvbox_dark'

      [palettes.gruvbox_dark]
      color_fg0 = '#fbf1c7'
      color_bg1 = '#3c3836'
      color_bg3 = '#665c54'
      color_blue = '#458588'
      color_aqua = '#689d6a'
      color_green = '#98971a'
      color_orange = '#d65d0e'
      color_purple = '#b16286'
      color_red = '#cc241d'
      color_yellow = '#d79921'

      [palettes.vesper]
      color_fg0 = '#f5e6c8'
      color_bg1 = '#1a1814'
      color_bg3 = '#5a524a'
      color_blue = '#5a524a'
      color_aqua = '#c4a35a'
      color_green = '#c4a35a'
      color_orange = '#c4a35a'
      color_purple = '#7c6f64'
      color_red = '#e05c5c'
      color_yellow = '#c4a35a'

      [palettes.rosepine]
      color_fg0 = '#e0def4'
      color_bg1 = '#26233a'
      color_bg3 = '#403d52'
      color_blue = '#31748f'
      color_aqua = '#9ccfd8'
      color_green = '#9ccfd8'
      color_orange = '#eb6f92'
      color_purple = '#c4a7e7'
      color_red = '#eb6f92'
      color_yellow = '#f6c177'

      [palettes.kanagawa]
      color_fg0 = '#dcd7ba'
      color_bg1 = '#363646'
      color_bg3 = '#54546d'
      color_blue = '#2d4f67'
      color_aqua = '#76946a'
      color_green = '#98bb6c'
      color_orange = '#c34043'
      color_purple = '#957fb8'
      color_red = '#c34043'
      color_yellow = '#dca561'

      [palettes.oceanic]
      color_fg0 = '#e8f4f8'
      color_bg1 = '#172a3a'
      color_bg3 = '#0077b6'
      color_blue = '#1b6ca8'
      color_aqua = '#00b4d8'
      color_green = '#90e0ef'
      color_orange = '#48cae4'
      color_purple = '#0077b6'
      color_red = '#ef476f'
      color_yellow = '#90e0ef'

      [palettes.jungle]
      color_fg0 = '#d8f3dc'
      color_bg1 = '#0d1f12'
      color_bg3 = '#1b4332'
      color_blue = '#1b4332'
      color_aqua = '#40916c'
      color_green = '#95d5b2'
      color_orange = '#52b788'
      color_purple = '#2d6a4f'
      color_red = '#74c69d'
      color_yellow = '#52b788'

      [palettes.matrix]
      color_fg0 = '#00ff41'
      color_bg1 = '#010801'
      color_bg3 = '#004d07'
      color_blue = '#004d07'
      color_aqua = '#007a0e'
      color_green = '#00cc34'
      color_orange = '#00640a'
      color_purple = '#003d05'
      color_red = '#00ff41'
      color_yellow = '#00a613'

      [palettes.mercury]
      color_fg0 = '#e8e8e8'
      color_bg1 = '#1a1a1a'
      color_bg3 = '#3d3d3d'
      color_blue = '#3d3d3d'
      color_aqua = '#6e6e6e'
      color_green = '#8a8a8a'
      color_orange = '#5c5c5c'
      color_purple = '#4a4a4a'
      color_red = '#aaaaaa'
      color_yellow = '#8a8a8a'

      [palettes.venus]
      color_fg0 = '#fff8e6'
      color_bg1 = '#1f1500'
      color_bg3 = '#9e6507'
      color_blue = '#9e6507'
      color_aqua = '#c8860a'
      color_green = '#f0c040'
      color_orange = '#c8860a'
      color_purple = '#7a5500'
      color_red = '#e8b84b'
      color_yellow = '#e8b84b'

      [palettes.mars]
      color_fg0 = '#f9ddd9'
      color_bg1 = '#1a0900'
      color_bg3 = '#8c2e1a'
      color_blue = '#8c2e1a'
      color_aqua = '#b03a2e'
      color_green = '#d4764a'
      color_orange = '#b03a2e'
      color_purple = '#6b2a18'
      color_red = '#c1623a'
      color_yellow = '#c1623a'

      [palettes.jupiter]
      color_fg0 = '#fdf0e0'
      color_bg1 = '#1e1000'
      color_bg3 = '#a07840'
      color_blue = '#a07840'
      color_aqua = '#d4a06a'
      color_green = '#e8c49a'
      color_orange = '#c45e2a'
      color_purple = '#6a4420'
      color_red = '#c45e2a'
      color_yellow = '#e8c49a'

      [palettes.saturn]
      color_fg0 = '#faf5e4'
      color_bg1 = '#1a1800'
      color_bg3 = '#a08830'
      color_blue = '#a08830'
      color_aqua = '#c8a84b'
      color_green = '#d4c070'
      color_orange = '#c8a84b'
      color_purple = '#6a5a20'
      color_red = '#d4c070'
      color_yellow = '#e8ddb0'

      [palettes.uranus]
      color_fg0 = '#e0f5f5'
      color_bg1 = '#051618'
      color_bg3 = '#1d6668'
      color_blue = '#1d6668'
      color_aqua = '#2a7c7e'
      color_green = '#7dd4d6'
      color_orange = '#2a7c7e'
      color_purple = '#1d5a5c'
      color_red = '#5bbcbe'
      color_yellow = '#5bbcbe'

      [palettes.neptune]
      color_fg0 = '#dce4ff'
      color_bg1 = '#060a1e'
      color_bg3 = '#1e2d88'
      color_blue = '#1e2d88'
      color_aqua = '#2c3e9e'
      color_green = '#7888e8'
      color_orange = '#2c3e9e'
      color_purple = '#1e2860'
      color_red = '#5b6fd4'
      color_yellow = '#5b6fd4'

      [palettes.earth]
      color_fg0 = '#e8f5ec'
      color_bg1 = '#050f18'
      color_bg3 = '#1a5c8a'
      color_blue = '#1565a8'
      color_aqua = '#1a5c8a'
      color_green = '#2e7d4f'
      color_orange = '#2e7d4f'
      color_purple = '#1a4060'
      color_red = '#b8903a'
      color_yellow = '#b8903a'

      [palettes.earth_night2]
      color_fg0 = '#ffd060'
      color_bg1 = '#100a00'
      color_bg3 = '#241600'
      color_blue = '#241600'
      color_aqua = '#342200'
      color_green = '#ffc840'
      color_orange = '#2e1e00'
      color_purple = '#4a3000'
      color_red = '#e8a840'
      color_yellow = '#ffb830'

      [palettes.earth_night]
      color_fg0 = '#ffd060'
      color_bg1 = '#100a00'
      color_bg3 = '#3a2600'
      color_blue = '#2e1e00'
      color_aqua = '#5a3c00'
      color_green = '#ffc840'
      color_orange = '#4a2e00'
      color_purple = '#4a3000'
      color_red = '#e8a840'
      color_yellow = '#6b3d00'

      [os]
      disabled = false
      style = "bg:color_orange fg:color_fg0"

      [os.symbols]
      Windows = "󰍲"
      Ubuntu = "󰕈"
      SUSE = ""
      Raspbian = "󰐿"
      Mint = "󰣭"
      Macos = "󰀵"
      Manjaro = ""
      Linux = "󰌽"
      Gentoo = "󰣨"
      Fedora = "󰣛"
      Alpine = ""
      Amazon = ""
      Android = ""
      AOSC = ""
      Arch = "󰣇"
      Artix = "󰣇"
      EndeavourOS = ""
      CentOS = ""
      Debian = "󰣚"
      Redhat = "󱄛"
      RedHatEnterprise = "󱄛"
      Pop = ""

      [username]
      show_always = true
      style_user = "bg:color_orange fg:color_fg0"
      style_root = "bg:color_orange fg:color_fg0"
      format = '[ $user ]($style)'

      [hostname]
      style = "bg:color_orange fg:color_fg0"
      format = "[ $ssh_symbol$hostname ]($style)"

      [directory]
      style = "fg:color_fg0 bg:color_yellow"
      format = "[ $path ]($style)"
      truncation_length = 3
      truncation_symbol = "…/"

      [directory.substitutions]
      "Documents" = "󰈙 "
      "Downloads" = " "
      "Music" = "󰝚 "
      "Pictures" = " "
      "Developer" = "󰲋 "

      [git_branch]
      symbol = ""
      style = "bg:color_aqua"
      format = '[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)'

      [git_status]
      style = "bg:color_aqua"
      format = '[[($all_status$ahead_behind )](fg:color_fg0 bg:color_aqua)]($style)'

      [nodejs]
      symbol = ""
      style = "bg:color_blue"
      format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

      [c]
      symbol = " "
      style = "bg:color_blue"
      format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

      [cpp]
      symbol = " "
      style = "bg:color_blue"
      format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

      [rust]
      symbol = ""
      style = "bg:color_blue"
      format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

      [golang]
      symbol = ""
      style = "bg:color_blue"
      format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

      [php]
      symbol = ""
      style = "bg:color_blue"
      format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

      [java]
      symbol = ""
      style = "bg:color_blue"
      format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

      [kotlin]
      symbol = ""
      style = "bg:color_blue"
      format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

      [haskell]
      symbol = ""
      style = "bg:color_blue"
      format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

      [python]
      symbol = ""
      style = "bg:color_blue"
      format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

      [docker_context]
      symbol = ""
      style = "bg:color_bg3"
      format = '[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)'

      [conda]
      style = "bg:color_bg3"
      format = '[[ $symbol( $environment) ](fg:#83a598 bg:color_bg3)]($style)'

      [pixi]
      style = "bg:color_bg3"
      format = '[[ $symbol( $version)( $environment) ](fg:color_fg0 bg:color_bg3)]($style)'

      [time]
      disabled = false
      time_format = "%R"
      style = "bg:color_bg1"
      format = '[[  $time ](fg:color_fg0 bg:color_bg1)]($style)'

      [line_break]
      disabled = false

      [character]
      disabled = false
      success_symbol = '[](bold fg:color_green)'
      error_symbol = '[](bold fg:color_red)'
      vimcmd_symbol = '[](bold fg:color_green)'
      vimcmd_replace_one_symbol = '[](bold fg:color_purple)'
      vimcmd_replace_symbol = '[](bold fg:color_purple)'
      vimcmd_visual_symbol = '[](bold fg:color_yellow)'
    '';
  };
}