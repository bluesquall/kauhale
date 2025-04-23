{ inputs, outputs, lib, config, pkgs, nixgl, home-manager, ragenix, ... }:
let
  USERNAME = "squall";
in
{
  imports = [
    ./fish
    # ./i3 # I've moved this, but not tested yet, since I'm revising hm on Pop!OS
    ./neovim
    ./tmux
    # ./wezterm
    ./zsh
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  nixGL = {
    packages = import nixgl { inherit pkgs; };
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;
  home = {
    username = "${USERNAME}";
    homeDirectory = "/home/${USERNAME}";
    stateVersion = "22.11";

    packages = with pkgs; [
      age
      agenix
      bibiman
      clolcat
      dotacat
      less
      nerd-fonts.fira-code
      nerd-fonts.mononoki
      pinentry-curses
      tree
      xterm
    ];

    file = {
      ".Xresources".source = ./Xresources;
    };
  };

  programs = {

    fzf.enable = true;

    git = {
      enable = true;
      userName = "M Jordan Stanway";
      userEmail = "m.j.stanway@alum.mit.edu";
      extraConfig = {
        init.defaultBranch = "main";
        pull = {
          rebase = true;
        };
        push = {
          autoSetupRemote = true;
        };
        diff = {
          wsErrorHighlight = "all";
        };
      };
    };

    gpg.enable = true;

    helix = {
      enable = true;
      settings = {
        theme = "catppuccin_macchiato";
      };
    };

    kakoune = {
      enable = true;
      defaultEditor = true;
      config = {
        colorScheme = "zenburn";
        tabStop = 2;
      };
    };

    password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_DIR = "${config.xdg.configHome}/password-store";
      };
    };

    starship = {
      enable = true;
      enableInteractive = true;
      settings = {
        "$schema" = "https://starship.rs/config-schema.json";
        add_newline = false;
        shell = {
          fish_indicator = "🐟";
          nu_indicator = "𝜈"; # math italic small nu
          powershell_indicator = "_";
          # zsh_indicator = "ℤ"; # double-struck Z
          zsh_indicator = "𝕫"; # math double-struck small z
          unknown_indicator = "?";
          disabled = false;
        };
      };
    };

  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 14400;
      maxCacheTtl = 86400;
      pinentryPackage = pkgs.pinentry-curses;
      extraConfig = ''
      '';
    };
  };

  xdg.enable = true;

  systemd.user.startServices = "sd-switch";
}
