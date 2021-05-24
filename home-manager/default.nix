{ pkgs, ... }:
{
  imports = [
    ./desktop.nix
    ./zsh.nix
    ./neovim.nix
  ];

  programs.git = {
    enable = true;
    userName = "Tyler Slabinski";
    userEmail = "tslabinski@slabity.net";
    ignores = [ ".*" ];
  };

  programs.ssh = {
    enable = true;
    forwardAgent = true;
  };

  programs.rofi = {
    enable = true;
    font = "sans-serif bold 8";
    colors = {
      window = {
        border = "#CC4349";
        separator = "#FFFFFF";
        background = "#131313";
      };

      rows = {
        normal = {
          background = "#131313";
          foreground = "#DFDFDF";
          backgroundAlt = "#CC131E";
          highlight = {
            background = "#CC6E13";
            foreground = "#DFDFDF";
          };
        };
      };
    };
  };

  services.kdeconnect.enable = true;

  home.packages = with pkgs; [
    zsh-completions
    nix-zsh-completions

    discord
    element-desktop
    firefox-wayland
    patchage
    pavucontrol
    prusa-slicer
    rofi
    spotify
    steam
    waybar
  ];
}
