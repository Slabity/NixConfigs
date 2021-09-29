{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    package = null;
    config = {
      modifier = "Mod4";
      bars = [];
      colors = {
        focused = {
          border = "#FF1D04";
          background = "#FF1D04";
          text = "#FF1D04";
          indicator = "#FF1D04";
          childBorder = "#FF1D04";
        };
        focusedInactive = {
          border = "#F07B6C00";
          background = "#F07B6C";
          text = "#F07B6C";
          indicator = "#F07B6C";
          childBorder = "#F07B6C";
        };
        unfocused = {
          border = "#6A3D3700";
          background = "#6A3D37";
          text = "#6A3D37";
          indicator = "#6A3D37";
          childBorder = "#6A3D37";
        };
        urgent = {
          border = "#900000";
          background = "#900000";
          text = "#900000";
          indicator = "#900000";
          childBorder = "#900000";
        };
        placeholder = {
          border = "#F07B6C";
          background = "#F07B6C";
          text = "#F07B6C";
          indicator = "#F07B6C";
          childBorder = "#F07B6C";
        };
      };
      floating = {
        modifier = "Mod4";
        titlebar = false;
      };
      gaps = {
        inner = 2;
      };
      keybindings = let modifier = "Mod4"; in {
        "${modifier}+Return" = "exec alacritty";
        "${modifier}+Shift+Return" = "exec i3-sensible-terminal";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+d" = "exec  --no-startup-id rofi -show run";
        "${modifier}+k" = "focus up";
        "${modifier}+j" = "focus down";
        "${modifier}+h" = "focus left";
        "${modifier}+l" = "focus right";
        "${modifier}+a" = "focus parent";
        "${modifier}+space" = "focus mode_toggle";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+l" = "move right";
        "${modifier}+v" = "split v";
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+f" = "fullscreen toggle";
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
        "${modifier}+Shift+1" = "move container to workspace 1";
        "${modifier}+Shift+2" = "move container to workspace 2";
        "${modifier}+Shift+3" = "move container to workspace 3";
        "${modifier}+Shift+4" = "move container to workspace 4";
        "${modifier}+Shift+5" = "move container to workspace 5";
        "${modifier}+Shift+6" = "move container to workspace 6";
        "${modifier}+Shift+7" = "move container to workspace 7";
        "${modifier}+Shift+8" = "move container to workspace 8";
        "${modifier}+Shift+9" = "move container to workspace 9";
        "${modifier}+Shift+0" = "move container to workspace 10";
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+r" = "restart";
      };
    };
  };

  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        height = 1;

        modules-left = [
          "sway/workspaces"
          "custom/right-arrow-dark"
        ];

        modules-center = [
          "custom/left-arrow-dark"
          "clock#1"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "clock#2"
          "custom/right-arrow-dark"
          "custom/right-arrow-light"
          "clock#3"
          "custom/right-arrow-dark"
        ];

        modules-right = [
          "custom/left-arrow-dark"
          "pulseaudio"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "memory"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "cpu"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "disk"
          "custom/left-arrow-light"
          "custom/left-arrow-dark"
          "tray"
        ];

        modules = {
          "custom/left-arrow-dark" = {
            format = "";
            tooltip = false;
          };

          "custom/left-arrow-light" = {
            format = "";
            tooltip = false;
          };

          "custom/right-arrow-dark" = {
            format = "";
            tooltip = false;
          };

          "custom/right-arrow-light" = {
            format = "";
            tooltip = false;
          };

          "sway/workspaces" = {
            disable-scroll = true;
            format = "{name}";
          };

          "clock#1" = {
            format = "{:%a}";
            tooltip = false;
          };

          "clock#2" = {
            format = "{:%H:%M}";
            tooltip = false;
          };

          "clock#3" = {
            format = "{:%m-%d}";
            tooltip = false;
          };

          "memory" = {
            interval = 1;
            format = "Mem: {}%";
          };

          "cpu" = {
            interval = 1;
            format = "CPU: {}%";
          };

          "disk" = {
            interval = 1;
            format = "Disk: {percentage_used:2}%";
            path = "/";
          };

          "tray" = {
            icon-size = 14;
            spacing = 4;
          };
        };
      }
    ];

    style = ''
      * {
        min-height: 0;
        font-size: 12px;
        font-family: Terminus;
      }

      window {
        margin: 50px;
        padding: 50px;
      }

      window#waybar {
        background: rgba(0,0,0,0);
        /* background: #292b2e; */
        color: #fdf6e3;
      }

      #custom-right-arrow-dark,
      #custom-left-arrow-dark {
        color: #1a1a1a;
      }
      #custom-right-arrow-light,
      #custom-left-arrow-light {
        color: #292b2e;
        background: #1a1a1a;
      }

      #workspaces,
      #clock.1,
      #clock.2,
      #clock.3,
      #pulseaudio,
      #memory,
      #cpu,
      #battery,
      #disk,
      #tray {
        background: #1a1a1a;
        padding: 0 5px;
      }

      #workspaces button {
        padding: 0 2px;
        color: #fdf6e3;
      }
      #workspaces button.focused {
        color: #268bd2;
      }
      #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
      }
      #workspaces button:hover {
        background: #1a1a1a;
        border: #1a1a1a;
        padding: 0 3px;
      }

      #pulseaudio {
        color: #268bd2;
      }
      #memory {
        color: #2aa198;
      }
      #cpu {
        color: #6c71c4;
      }
      #battery {
        color: #859900;
      }
      #disk {
        color: #b58900;
      }

      #clock,
      #pulseaudio,
      #memory,
      #cpu,
      #battery,
      #disk {
        padding: 0 5px;
      }
    '';
  };

  services.kanshi = {
    enable = true;
    profiles = {
      default = {
        outputs = [
          {
            criteria = "DP-2";
            mode = "2560x1440";
            position = "0,0";
            transform = "90";
          }
          {
            criteria = "HDMI-A-2";
            mode = "3440x1440";
            position = "1440,900";
          }
          #{
          #  criteria = "DP-1";
          #  mode = "2880x1600";
          #  status = "disable";
          #}
        ];
      };
    };
  };

  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        bars = [];
        colors = {
          focused = {
            border = "#FF1D04";
            background = "#FF1D04";
            text = "#FF1D04";
            indicator = "#FF1D04";
            childBorder = "#FF1D04";
          };
          focusedInactive = {
            border = "#F07B6C00";
            background = "#F07B6C";
            text = "#F07B6C";
            indicator = "#F07B6C";
            childBorder = "#F07B6C";
          };
          unfocused = {
            border = "#6A3D3700";
            background = "#6A3D37";
            text = "#6A3D37";
            indicator = "#6A3D37";
            childBorder = "#6A3D37";
          };
          urgent = {
            border = "#900000";
            background = "#900000";
            text = "#900000";
            indicator = "#900000";
            childBorder = "#900000";
          };
          placeholder = {
            border = "#F07B6C";
            background = "#F07B6C";
            text = "#F07B6C";
            indicator = "#F07B6C";
            childBorder = "#F07B6C";
          };
        };
        floating = {
          modifier = "Mod4";
          titlebar = false;
        };
        gaps = {
          inner = 4;
        };
        keybindings = let modifier = "Mod4"; in {
          "${modifier}+Return" = "exec alacritty";
          "${modifier}+Shift+Return" = "exec i3-sensible-terminal";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec  --no-startup-id rofi -show run";
          "${modifier}+k" = "focus up";
          "${modifier}+j" = "focus down";
          "${modifier}+h" = "focus left";
          "${modifier}+l" = "focus right";
          "${modifier}+a" = "focus parent";
          "${modifier}+space" = "focus mode_toggle";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+l" = "move right";
          "${modifier}+v" = "split v";
          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";
          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+f" = "fullscreen toggle";
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
          "${modifier}+Shift+1" = "move container to workspace 1";
          "${modifier}+Shift+2" = "move container to workspace 2";
          "${modifier}+Shift+3" = "move container to workspace 3";
          "${modifier}+Shift+4" = "move container to workspace 4";
          "${modifier}+Shift+5" = "move container to workspace 5";
          "${modifier}+Shift+6" = "move container to workspace 6";
          "${modifier}+Shift+7" = "move container to workspace 7";
          "${modifier}+Shift+8" = "move container to workspace 8";
          "${modifier}+Shift+9" = "move container to workspace 9";
          "${modifier}+Shift+0" = "move container to workspace 10";
          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+r" = "restart";
        };
      };
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "monospace";
      font.size = 9;
      colors = {
        primary.background = "#1a1414";
        primary.foreground = "#f2c2c2";
        normal.black = "#4d0000";
        normal.red = "#8c1515";
        normal.green = "#a62121";
        normal.yellow = "#b33e3e";
        normal.blue = "#bf6060";
        normal.magenta = "#997373";
        normal.cyan = "#990000";
        normal.white = "#665252";
        bright.black = "#cc0000";
        bright.red = "#ff3333";
        bright.green = "#ff4d4d";
        bright.yellow = "#ff6666";
        bright.blue = "#ff8080";
        bright.magenta = "#e69595";
        bright.cyan = "#ffcccc";
        bright.white = "#231919";
      };
      bell = {
        animation = "EaseOutCirc";
        duration = 100;
        color = "0x221414";
      };
    };
  };

  services.redshift = {
    enable = true;
    package = pkgs.redshift-wlr;
    latitude = "20";
    longitude = "-71";
    temperature.day = 6500;
    temperature.night = 3500;
    settings = {
      redshift.brightness-day = 1.00;
      redshift.brightness-night = 0.75;
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "Noto Sans 10";
    };
    iconTheme = {
      package = pkgs.arc-icon-theme;
      name = "Arc";
    };
    theme = {
      package = pkgs.adapta-gtk-theme;
      name = "Adapta-Nokto-Eta";
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "TerminessTTF Nerd Font Mono 11";
        allow_markup = true;

        format = "<b>%s</b>\n%b";

        sort = true;
        indicate_hidden = true;
        bounce_freq = 0;
        show_age_threshold = 60;
        word_wrap = true;
        ignore_newline = false;

        geometry = "600x5-20+45";
        shrink = false;

        transparency = 0;
        idle_threshold = 0;
        monitor = 0;
        follow = "mouse";
        sticky_history = true;
        history_length = 20;
        show_indicators = true;

        line_height = 0;
        separator_height = 2;
        padding = 9;
        horizontal_padding = 9;
        separator_color = "frame";

        startup_notification = false;
      };
      frame = {
        width = 3;
        color = "#ebdbb2";
      };
      shortcuts = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
        context = "ctrl+shift+period";
      };
      urgency_low = {
        background = "#282828";
        foreground = "#ebdbb2";
        timeout = 5;
      };
      urgency_normal = {
        background = "#282828";
        foreground = "#ebdbb2";
        timeout = 5;
      };
      urgency_critical = {
        background = "#cc241d";
        foreground = "#ebdbb2";
        timeout = 0;
      };
    };
  };

  xresources.extraConfig = ''
    ! Color scheme
    #define BLACK_D #232323
    #define BLACK_L #494949

    #define GREY_D #7F7F7F
    #define GREY_L #AAAAAA

    #define WHITE_D #CCCCCC
    #define WHITE_L #EFEFEF

    #define ORANGE_D #CC6E13
    #define ORANGE_L #CC8743

    #define ORANGERED_D #CC3F13
    #define ORANGERED_L #CC6443

    #define RED_D #CC131E
    #define RED_L #CC4349

    #define FUSCHIA_D #CC13C0
    #define FUSCHIA_L #CC43C2

    #define PURPLE_D #7C19CC
    #define PURPLE_L #9349CC

    #define FG #DFDFDF
    #define BG #131313

    *saveLines: 8192
    ! *font: Monospace 8
    *letterSpace: 0
    *lineSpace: 0

    ! special
    *.foreground: FG
    *.background: BG

    *.color0: BLACK_D
    *.color8: BLACK_L
    *.color1: ORANGE_D
    *.color9: ORANGE_L
    *.color2: ORANGERED_D
    *.color10: ORANGERED_L
    *.color3: RED_D
    *.color11: RED_L
    *.color4: FUSCHIA_D
    *.color12: FUSCHIA_L
    *.color5: PURPLE_D
    *.color13: PURPLE_L
    *.color6: GREY_D
    *.color14: GREY_L
    *.color7: WHITE_D
    *.color15: WHITE_L

    ! urxvt config
    URxvt.scrollBar: false
    URxvt.perl-ext-common: default,matcher,font-size,vtwheel,keyboard-select,clipboard
    URxvt.termName: rxvt-unicode-256color

    ! rofi config
    ! rofi.color-enabled: true
    ! rofi.color-normal:  BG,FG,RED_D,ORANGE_D,FG
    ! rofi.color-window:  BG,RED_L

    Xft.dpi: 96
  '';
}
