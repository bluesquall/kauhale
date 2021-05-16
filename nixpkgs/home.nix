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
      st
      tree
    ];

    file = {

      "i3.config" = {
        target = ".config/i3/config";
        text = ''
set $mod Mod4
font pango:monospace 8
bindsym $mod+Return exec st -f "Deja Vu Sans Mono:size=13" $HOME/.nix-profile/bin/fish
bindsym $mod+z exec SHELL=$HOME/.nix-profile/bin/fish cool-retro-term
bindsym $mod+b exec firefox
bindsym $mod+Shift+q kill
bindsym $mod+d exec dmenu_run
bindsym $mod+h split h
bindsym $mod+v split v
bindsym $mod+f fullscreen toggle
bindsym $mod+Shift+r restart
bindsym $mod+Shift+c reload
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"
set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws10 "10"
bindsym $mod+1 workspace number $ws1
bindsym $mod+2 workspace number $ws2
bindsym $mod+3 workspace number $ws3
bindsym $mod+4 workspace number $ws4
bindsym $mod+5 workspace number $ws5
bindsym $mod+6 workspace number $ws6
bindsym $mod+7 workspace number $ws7
bindsym $mod+8 workspace number $ws8
bindsym $mod+9 workspace number $ws9
bindsym $mod+0 workspace number $ws10
bindsym $mod+Shift+1 move container to workspace number $ws1
bindsym $mod+Shift+2 move container to workspace number $ws2
bindsym $mod+Shift+3 move container to workspace number $ws3
bindsym $mod+Shift+4 move container to workspace number $ws4
bindsym $mod+Shift+5 move container to workspace number $ws5
bindsym $mod+Shift+6 move container to workspace number $ws6
bindsym $mod+Shift+7 move container to workspace number $ws7
bindsym $mod+Shift+8 move container to workspace number $ws8
bindsym $mod+Shift+9 move container to workspace number $ws9
bindsym $mod+Shift+0 move container to workspace number $ws10
bar {
        status_command i3status
}
exec xinput set-prop (xinput list --name-only | grep Touchpad) 'libinput Tapping Enabled' 1
        '';
      };

#      "nix.conf" = {
#        target = ".config/nix/nix.conf";
#        text = "experimental-features = nix-command flakes";
#      };

      "user-dirs.dirs" = {
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

      ".Xresources" = {
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

      # The following are shell completions that *may* not be installed by the tools themselves.
      "pass.fish-completion" = {
        target = ".config/fish/completions/pass.fish-completion";
        source = builtins.fetchurl {
          url = "https://git.zx2c4.com/password-store/plain/src/completion/pass.fish-completion";
          sha256 = "0clddzzkdcic3la95a4s72lz3yjdm7kgjgdkjxlx65sdrzscmnbj";
        };
      };

      # The following utilities could be aliases, but I'd like access to them in any shell.
      "ssh-copy-terminfo" = {
        executable = true;
        target = ".local/bin/ssh-copy-terminfo";
        text = ''
#!/bin/bash
TERMINFO=~/.nix-profile/share/terminfo infocmp | ssh $@ "cat > /tmp/terminfo && tic -x /tmp/terminfo; rm /tmp/terminfo"
        '';
      };

    };
  };

  programs = {

    direnv = {
      enable = true;
      enableNixDirenvIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    fish = {
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
        {
          name = "theme-will";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "theme-will";
            rev = "c33cdd5f013bc50be78cee968fe7a2b4b574fca9";
            sha256 = "0667z3fzbqjb8dhkw2nj5hc76nzydai4na9ji7vd4x4lb8wbhnfk";
          };
        }
      ];
      interactiveShellInit = "set fish_greeting"; # get rid of the greeting
    };

    git = {
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

    gpg = {
      enable = true;
      homedir = "${config.home.homeDirectory}/.config/gnupg";
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraConfig = ''
" let g:solarized_termcolors=256
colorscheme solarized
set background=dark
nnoremap <F6> :let &bg=(&bg=='light'?'dark':'light')
set cursorline
set linebreak
set clipboard=unnamedplus
set expandtab
set tabstop=2
set shiftwidth=2
let g:markdown_fenced_languages = ['shell=sh', 'c', 'python']
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

    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [
        exts.pass-checkup exts.pass-otp exts.pass-tomb
      ]);
      settings = {
        PASSWORD_STORE_DIR = "$XDG_CONFIG_HOME/password-store";
        PASSWORD_STORE_CHARACTER_SET = "[:alnum:]%&_?#=-";
        PASSWORD_STORE_CLIP_TIME = "60";
      };
    };

    tmux = {
      enable = true;
      extraConfig = ''
# --- colors (~solarized dark)
set -g status-bg black
set -g status-fg yellow
set -g display-panes-active-colour yellow
set -g display-panes-colour brightblue
setw -g clock-mode-colour yellow
# --- end colors
      '';
    };

    zsh = {
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
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_CACHE_HOME = "$HOME/.cache";
        LCM_DEFAULT_URL = udpm://239.255.76.67:7667?ttl=1;
      };
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
  };
}
