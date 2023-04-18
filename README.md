# kauhale

> from Hawai'ian
> meaning "group of houses comprising a home"
> literally "plural house"

This is my [NixOS] home.

## getting started


### [NixOS] with flakes

0. get a [NixOS] live system, e.g., from the [NixOS download page], or by
   building one of the ISO images from this repo's `flake.nix`:

   `nix build .#nixosConfigurations.minimalIso.config.system.build.isoImage`

1. boot into the [NixOS] live system

   - connect to your WiFi network:

     `nmcli device wifi connect <SSID> --ask`

2. install NixOS

   a. directly from the remote:

      `nixos-install --flake github:bluesquall/kauhale/main/nixos#encom`

   b. clone this repo, modify accordingly, and install

     - `git clone https://github.com/bluesquall/kauhale.git`

     - modify to suit your needs

     - `nixos-install --flake .#encom` or `nixos-install --system ./os/encom.nix`



3. reboot

### [Home Manager] with flakes

With [Home Manager], you can still declare your user environment on another
Linux distribution besides NixOS (e.g., Debian, Ubuntu, Arch) and even on
Mac OS X.

0. install `nix`[^0]

   `sh <(curl -L https://nixos.org/nix/install) --daemon`

1. install `home-manager`[^1]

   `nix run home-manager/master -- init --switch`

2. switch to your flake[^2]:

   `home-manager switch --flake ~/src/kauhale#squall`

   or, if you have different home configurations for different hosts:

   `home-manager switch --flake ~/src/kauhale#$(whoami)@$(hostname)`

## ramblin'

After using Arch Linux for many years, I'm trying out NixOS. I've written a
[system initialization script][mknix] to automate setup using a NixOS live
disk. It is inspired by, and heavily patterned after, [a post][mt-caret]
about setting up [darling erasure][eyd] on an encrypted btrfs volume. (I
have not yet started using darling erasure -- I'm still getting used to
NixOS first.)

### to-do

* test-drive [homies]

* review [this post][mathiasp] on setting up a dev environment using Nix and
  decide what to apply to my approach

* package [LCM] using [flakes]

## environment

### dotfiles

It seems like most [NixOS] users manage their dotfiles with [home-manager],
but [homies] seems like an attractive alternative. It also looks like you
may be able to set up something using [flakes].

### shell

My login shell is `zsh` so that anything expecting POSIX compliance will get
it, but my keyboard shortcut for the terminal uses `fish` so that's what I
have for most interactive shells on the machine. We will see how this fares.
Kudos to Matt Hart for [suggesting this approach in a post][fish-n-nix]. I
haven't needed `fenv` yet, but that may a difference between using NixOS and
using `nix` on top of a different OS.

### terminal emulators

On my Arch installations, I've started to use `kitty`, and I may continue to
use it on my NixOS installations, but to keep the base derivation minimal I
rely first on `uxterm` with a few customizations in `~/.Xresources` to keep
it from blinding me with a white background.

Here's the relevant line in `~/.config/i3/config`:

```
bindsym $mod+Return exec "SHELL=$HOME/.nix-profile/bin/fish uxterm"
```

### editor

Started with `vim` many years ago so that I'd be learning something I could
count on having on robots and other embedded machines. Still plenty to learn
to be more effective and efficient.

Using `nvim` on the NixOS installations -- need to figure out how to alias
it in the nix configs.

### password manager

Use one! `pass` works for me.

### unstable channel

If you need packages from `nixos-unstable` for your installation, and you
would rather not have to run `nix-channel --add` & `nix-channel --update`
to make out-of-band changes to the system before `nixos-rebuild switch`, our
friend at [functor.tokyo shows us how to reference it directly][functokyo]
in `configuration.nix` and avoid relying on external state.



_____________
[^0]: See the [NixOS download page].
[^1]: See the [Home Manager chapter on flakes]. I used the installation
      command for the unstable version because it worked the first time, and
      does not depend on the flake in this repository working correctly. You
      can always remove or overwrite the basic configuration it installs (in
      `$XDG_CONFIG_HOME/home-manager` by default) or redirect the init to a
      temporary folder: `nix run home-manager/master -- init /tmp/hm`.
_____________

[NixOS]: https://nixos.org
[NixOS download page]: https://nixos.org/download.html
[Home Manager]: https://github.com/nix-community/home-manager
[Home Manager chapter on flakes]: https://nix-community.github.io/home-manager/index.html#ch-nix-flakes
[mknix]: https://mjstanway.com/mknix
[mt-caret]: https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
[eyd]: https://grahamc.com/blog/erase-your-darlings
[homies-post]: https://www.nmattia.com/posts/2018-03-21-nix-reproducible-setup-linux-macos.html
[mathiasp]: https://www.mathiaspolligkeit.de/dev/exploring-nix-on-macos/
[fish-n-nix]: https://mjhart.netlify.app/posts/2020-03-14-nix-and-fish.html
[functokyo]: https://functor.tokyo/blog/2018-02-18-install-packages-from-nixos-unstable
[malloc47]: https://www.malloc47.com/migrating-to-nixos/
[del-old-boot-conf]: http://blog.ielliott.io/how-to-delete-old-nixos-boot-configurations/
[flakes]: https://www.tweag.io/blog/2020-05-25-flakes/
[hm-flakes]: https://dee.underscore.world/blog/home-manager-flakes/
[nix-flake-live]: https://hoverbear.org/blog/nix-flake-live-media/
[practical-nix-flakes]: https://serokell.io/blog/practical-nix-flakes

