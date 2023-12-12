{ pkgs, ... }: {
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./git.nix
    ./gtk.nix
    ./imv.nix
    ./khard.nix
    ./neomutt.nix
    ./pass.nix
    ./rofi.nix
    ./swaylock.nix
    ./tmux.nix
    ./waybar.nix
    ./xdg.nix
    ./zathura.nix
    ./zsh.nix
  ];

  # packages without setup
  home.packages = with pkgs; [
    # gui
    darktable
    inkscape
    mpv

    # cli and utils
    brightnessctl
    cargo
    libnotify
    nodejs
    openjdk
    texlive.combined.scheme-full
    urlscan
    wl-clipboard

    # language servers
    lua-language-server
    stylua
  ];
}
