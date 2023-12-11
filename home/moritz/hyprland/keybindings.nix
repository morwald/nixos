{ inputs, config, pkgs, lib, ... }:
let
  workspaces = map toString (lib.range 1 9);
  directions = {
    h = "l";
    l = "r";
    k = "u";
    j = "d";
  };
  resizes = {
    h = "-30 0";
    l = "30 0";
    k = "0 -30";
    j = "0 30";
  };
in {
  wayland.windowManager.hyprland.settings = {
    bindm = [ "SUPER,mouse:272,movewindow" "SUPER,mouse:273,resizewindow" ];

    bind = let
      brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      firefox = "${config.programs.firefox.package}/bin/firefox";
      grimblast = "${
          inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
        }/bin/grimblast";
      pactl = "${pkgs.pulseaudio}/bin/pactl";
      swaylock = "${config.programs.swaylock.package}/bin/swaylock";
      terminal = "${config.programs.alacritty.package}/bin/alacritty";
      makoctl = "${config.services.mako.package}/bin/makoctl";
    in [
      "SUPER,q,killactive"
      "SUPERSHIFT,q,exit"
      "SUPER,m,fullscreen"

      # program bindings
      "SUPERSHIFT,return,exec,${terminal}"
      "SUPER,w,exec,${firefox}"
      "SUPER,e,exec,${terminal} -e neomutt"

      # launcher rofi
      # TODO: modi doesn't work when specifying binary location of rofi
      "SUPER,o,exec,rofi -show drun"
      "SUPER,p,exec,rofi -show powermenu -modi powermenu:rofi-power-menu"
      "SUPERSHIFT,p,exec,rofi-pass"
      "SUPER,c,exec,rofi -show calc -modi calc"

      # config reloads (waybar has to be restarted for correct workspaces) 
      "SUPER,r,exec,hyprctl reload & systemctl --user restart waybar.service"
      "SUPERSHIFT,k,exec,kanshi reload & systemctl --user restart waybar.service"

      # screen lock
      "SUPER,backspace,exec,${swaylock}"

      # notification manager
      "SUPER,d,exec,${makoctl} dismiss"

      # volume control
      "SUPER,Up,exec,${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
      "SUPER,DOWN,exec,${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
      ",XF86AudioRaiseVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
      ",XF86AudioLowerVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
      ",XF86AudioMute,exec,${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
      ",XF86AudioMicMute,exec,${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"

      # brightness control
      ",XF86MonBrightnessUp,exec,${brightnessctl} s 5%+"
      ",XF86MonBrightnessDown,exec,${brightnessctl} s 5%-"

      # screenshots
      ",Print,exec,${grimblast} --notify save"
      "SHIFT,Print,exec,${grimblast} --notify save area"
    ] ++
    # change workspace
    (map (n: "SUPER,${n},workspace,name:${n}") workspaces) ++

    # move window to workspace
    (map (n: "SUPERSHIFT,${n},movetoworkspacesilent,name:${n}") workspaces) ++

    # move focus
    (lib.mapAttrsToList (key: direction: "SUPER,${key},movefocus,${direction}")
      directions) ++

    # resize window 
    (lib.mapAttrsToList (key: resize: "SUPERALT,${key},resizeactive,${resize}")
      resizes) ++

    # swap windows
    (lib.mapAttrsToList
      (key: direction: "SUPERSHIFT,${key},swapwindow,${direction}") directions);
  };
}
