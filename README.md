# kauhale

> from Hawai'ian
> meaning "group of houses comprising a home"
> literally "plural house"

This is my [NixOS](nixos.org) home.

## ramblin'

After using Arch Linux for many years, I'm trying out NixOS. I've written a
[system initialization script][mknix] to automate setup using a NixOS live
disk. It is inspired by, and heavily patterned after, [a post][mt-caret]
about setting up [darling erasure][eyd] on an encrypted btrfs volume. (I
have not yet started using darling erasure -- I'm still getting used to
NixOS first.)

### to-do

* test-drive [homies][homies-post]

* review [this post][mathiasp] on setting up a dev environment using Nix and
  decide what to apply to my approach

## environment

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


## references

[mknix]: https://mjstanway.com/mknix
[mt-caret]: https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
[eyd]: https://grahamc.com/blog/erase-your-darlings
[homies-post]: https://www.nmattia.com/posts/2018-03-21-nix-reproducible-setup-linux-macos.html
[mathiasp]: https://www.mathiaspolligkeit.de/dev/exploring-nix-on-macos/
[fish-n-nix]: https://mjhart.netlify.app/posts/2020-03-14-nix-and-fish.html
[functokyo]: https://functor.tokyo/blog/2018-02-18-install-packages-from-nixos-unstable
