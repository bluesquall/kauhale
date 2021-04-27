{ config, pkgs, lib, ... }:

{
  programs.home-manager.enable = true;

  home = {
    sessionVariables = {
      PAGER = "less";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    packages = with pkgs; [ brightnessctl curl docker less podman tree ];
    file.".Xresources" = {
      source = ../.Xresources;
      target = ".Xresources";
    };
    file."i3" = {
      source = ../i3;
      target = "./.config/i3";
      recursive = true;
    };
  };

  programs.bash = {
    enable = true;
    shellOptions = [ "autocd" "globstar" "extglob"];
    profileExtra = ''if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi'';
  };

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
        "git@github.com" = { insteadOf = "https://github.com/"; };
        "git@gitlab.com" = { insteadOf = "https://gitlab.com/"; };
        "git@bitbucket.org" = { insteadOf = "https://bitbucket.org/"; };
      };
      pull.rebase = true;
      push.simple = true;
    };
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
