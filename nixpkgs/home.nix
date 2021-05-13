{ config, pkgs, lib, ... }:

{
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  home = {
    sessionVariables = {
      PAGER = "less";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    packages = with pkgs; [
      brightnessctl
      curl
      dejavu_fonts 
      docker
      inconsolata
      less
      podman
      tree
    ];

    file."user-dirs.dirs" = {
      target = ".config/user-dirs.dirs";
      text = ''
XDG_DESKTOP_DIR="/tmp"
XDG_DOWNLOAD_DIR="/tmp"
XDG_TEMPLATES_DIR="/tmp"
XDG_PUBLICSHARE_DIR="/tmp"
XDG_DOCUMENTS_DIR="/tmp"
XDG_MUSIC_DIR="/tmp"
XDG_PICTURES_DIR="/tmp"
XDG_VIDEOS_DIR="/tmp"
      '';
    };

    file.".Xresources" = {
      target = ".Xresources";
      text = ''
UXTerm*foreground: orange
UXTerm*background: black
UXTerm*renderFont: true
!UXTerm*faceName: inconsolata
UXTerm*faceName: Deja Vu Sans Mono
UXTerm*faceSize: 10

XTerm*selectToClipboard: true
Ctrl Shift <Key>C: copy-selection(CLIPBOARD)
Ctrl Shift <Key>V: insert-selection(CLIPBOARD)
      '';
    };
    file."i3" = {
      source = ../i3;
      target = "./.config/i3";
      recursive = true;
    };
  };

###   programs.bash = {
###     enable = true;
###     historyIgnore = [ "ls" "cd" "pushd" "df" "du" "exit" ];
###     shellOptions = [ "autocd" "histappend" "extglob" "globstar" ];
###     profileExtra = ''
###       if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
###         source $HOME/.nix-profile/etc/profile.d/nix.sh;
###       fi
###       
###       if [ -d $HOME/.local/bin ]; then
###         PATH="$HOME/.local/bin:$PATH"
###       fi
### 
###       if [ -d $HOME/.config/profile.d ]; then
###         for profile in $HOME/.config/profile.d/*sh; do
###           source $profile;
###         done
###       fi
###     '';
###     bashrcExtra=''
###       if [ -e $HOME/.profile ]; then
###         source $HOME/.profile;
###       fi
###       
###       export PS1="\w $ "
###     '';
###   };

  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
  };

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
          sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
        };
      }
    ];
    loginShellInit = ''
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end

      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      end

      eval (direnv hook fish)

      set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
      gpg-connect-agent updatestartuptty /bye &> /dev/null
      '';
  };

  programs.git = {
    enable = true;
    userName = "M J Stanway";
    ignores = [ "*~" "*.swp" "*.pyc" "*.o" ".DS_Store" ];
    aliases = {
      st = "status";
      graph = "log --graph --abbrev-commit --decorate --date=relative --all";
    };
    extraConfig = {
      core = {
        editor = "nvim";
      };
      url = {
        "git@github.com:" = { insteadOf = "https://github.com/"; };
        "git@gitlab.com:" = { insteadOf = "https://gitlab.com/"; };
        "git@bitbucket.org:" = { insteadOf = "https://bitbucket.org/"; };
      };
      commit.gpgsign = true;
      init.defaultBranch = "main";
      pull.rebase = true;
      push.simple = true;
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = ''
      " let g:solarized_termcolors=256
      colorscheme solarized
      set background=dark
      set cursorline
      nnoremap <F6> :let &bg=(&bg=='light'?'dark':'light')
    '';
    plugins = with pkgs.vimPlugins;
      let
        vim-colors-solarized = pkgs.vimUtils.buildVimPlugin {
          name = "vim-colors-solarized";
	  src = pkgs.fetchFromGitHub {
            owner = "altercation";
	    repo = "vim-colors-solarized";
	    rev = "528a59f26d12278698bb946f8fb82a63711eec21";
	    sha256 = "05d3lmd1shyagvr3jygqghxd3k8a4vp32723fvxdm57fdrlyzcm1";
	  };
	};
      in [
        sensible
        vim-colors-solarized
	vim-nix
      ];
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
# --- colors (solarized dark)
# default statusbar colors
set -g status-bg black
set -g status-fg yellow
set -g status-attr default

# default window title colors
setw -g window-status-fg brightblue
setw -g window-status-bg default

# active window title colors
setw -g window-status-current-fg yellow
setw -g window-status-current-bg default
setw -g window-status-current-attr dim

# pane border
set -g pane-border-fg black
set -g pane-border-bg default
set -g pane-active-border-fg yellow
set -g pane-active-border-bg default

# command line/message text
set -g message-bg black
set -g message-fg yellow

# pane number display
set -g display-panes-active-colour yellow
set -g display-panes-colour brightblue

# clock
setw -g clock-mode-colour yellow
# --- end colors
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    envExtra = ''
      typeset -U path
      path=(~/bin ~/.local/bin /$path[@])
    '';

    defaultKeymap = "vicmd";
    dotDir = ".config/zsh";

    oh-my-zsh = {
      enable = true;
      theme = "half-life";
      plugins = [ "git" ];
    };

    sessionVariables = {
      LCM_DEFAULT_URL = udpm://239.255.76.67:7667?ttl=1;
      PASSWORD_STORE_DIR = "$XDG_CONFIG_HOME/pass";
      PASSWORD_STORE_CHARACTER_SET = "[:alnum:] %&_?#=-";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };

  };
}
