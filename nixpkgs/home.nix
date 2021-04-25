{ config, pkgs, lib, ... }:

{
  programs.home-manager.enable = true;

  home = {
    packages = with pkgs; [ tree ];
    sessionVariables = {
      PAGER = "less";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    # file.".Xresources".source = ../.Xresources;
  };

  programs.bash = {
    enable = true;
    shellOptions = [ "autocd" "globstar" "extglob"];
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
    defaultKeymap = "vicmd";
    dotDir = ".config/zsh";
  };
  
  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };

  };
}
