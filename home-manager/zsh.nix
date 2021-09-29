{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    dotDir = ".config/zsh";
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      path = ".config/zsh/history";
      save = 100000;
      share = true;
      size = 100000;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "common-aliases"
        "compleat"
        "dirhistory"
        "encode64"
        "fasd"
        "git"
        "git-extras"
        "git-prompt"
        "per-directory-history"
        "sudo"
        "systemd"
        "vi-mode"
        "wd"
      ];
      theme = "../../../../../..${pkgs.powerlevel10k}/powerlevel10k/powerlevel10k";
    };
    initExtra = ''
      DEFAULT_USER=slabity

      POWERLEVEL9K_MODE="nerdfont-complete"

      POWERLEVEL9K_DISABLE_GITSTATUS=true

      POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(vi_mode vcs dir dir_writable)
      POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs)
      POWERLEVEL9K_SHORTEN_STRATEGY=truncate_left

      POWERLEVEL9K_HOME_ICON="$(printf '\uf015')"
      POWERLEVEL9K_HOME_SUB_ICON="$(printf '\uf015')"
      POWERLEVEL9K_FOLDER_ICON="$(printf '\uf413')"
      POWERLEVEL9K_DIR_WRITABLE_ICON="$(printf '\uf413')"
      POWERLEVEL9K_LOCK_ICON="$(printf '\uf023')"

      POWERLEVEL9K_VI_INSERT_MODE_STRING="$(printf '\uf040')"
      POWERLEVEL9K_VI_COMMAND_MODE_STRING="$(printf '\uf120')"

      POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=true
      POWERLEVEL9K_DIR_PATH_SEPARATOR=" $(printf '\ue0b1') "

      POWERLEVEL9K_DIR_HOME_BACKGROUND="001"
      POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND=$POWERLEVEL9K_DIR_HOME_BACKGROUND
      POWERLEVEL9K_DIR_DEFAULT_BACKGROUND=$POWERLEVEL9K_DIR_HOME_BACKGROUND
      POWERLEVEL9K_DIR_HOME_FOREGROUND="aqua"
      POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=$POWERLEVEL9K_DIR_HOME_FOREGROUND
      POWERLEVEL9K_DIR_DEFAULT_FOREGROUND=$POWERLEVEL9K_DIR_HOME_FOREGROUND

      POWERLEVEL9K_VI_MODE_NORMAL_BACKGROUND="white"
      POWERLEVEL9K_VI_MODE_INSERT_BACKGROUND=$POWERLEVEL9K_VI_MODE_NORMAL_BACKGROUND
      POWERLEVEL9K_VI_MODE_NORMAL_FOREGROUND="aqua"
      POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND=$POWERLEVEL9K_VI_MODE_NORMAL_FOREGROUND

      POWERLEVEL9K_VCS_CLEAN_BACKGROUND="006"
      POWERLEVEL9K_VCS_CLEAN_FOREGROUND="001"
      POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="lime"
      POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="000"
      POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="lime"
      POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="000"

      compinit
    '';
  };
}
