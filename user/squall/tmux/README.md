# `tmux` configuration

I'll build this up slowly.
I've been using -- relying on, really -- `tmux` for a few years, mostly in robotics projects.
Recently I've started using it more day-to-day.
*And* I've never really configured it to meet my particular needs & style.

The video [A UX Expert Fixes My Tmux][yt-dot-ux] caught my eye,
and the story there resonated with me,
so I'll be cribbing some of this config from the [omerxx dotfiles][gh-omerxx-dotfiles] repo.
The main points that caught my eye & ear were:

- layout -- move the bar to the top, so it is:
  - closer to eye level
  - not stacked right below the `nvim` bar, putting too much information from two different contexts too close together
- softer contrast color scheme (though I can just let it inherit from my terminal)
- leveraging symbols -- non-alphanumeric glyphs are useful, I just have to avoid getting pulled into too much ricing
- less information (only what you really want/need, fewer distractions)
- the staged reminder popup
  - I usually don't like pop-ups, but I'm game to try a few that I have control over. I don't have many meetings to worry about right now, so the calendar reminder example isn't directly applicable, but I do believe I'd find a pomodoro timer useful.


## reviewing the [omerxx dotfiles][gh-omerxx-dotfiles]

Right at the top of `tmux.conf`, they start by sourcing another file.
I hadn't realized you could do that.
I don't need it right now because I'm able to use `builtinst.readFile` with `nix` & `home-manager`,
but it is good to know about nonetheless.

The file sourced actually starts by removing *all* keybindings,
then proceeds to opt in to the ones they want to use.
I'll probably keep most of the defaults, since I want to preserve my muscle memory
for working on robots and other shared accounts/systems where I don't have full control.

### layout

The main setting here is:
```
set -g status-position top       # macOS / darwin style
```
and I've already added it to `ux.tmux.conf`

### palette
They are using [catppuccin], and I'm going to test drive that for a while.
(I may return to [solarized] later, but will definitely stick with colors that preserve a bit lower contrast.)
It looks like they do not set the flavor, which defaults to `"mocha"`,
but I'm going to use `"macchiato"` for now,
> Medium contrast with gentle colors creating a soothing atmosphere.
to match what I've compiled into `st`.
I will make sure to set `nvim` to match as well, for consistency.

### symbols & information
It looks like most of the symbols and status bar information are set within the `catppuccin_` namespace.
I'm going to start with an exact copy from these dotfiles, and modify from there to suit my own preferences.
Since all these settings are in the `catppuccin_` namespace, I'm going to put them in `catppuccin.tmux.conf`,
even though I consider them to be part of the UX. That way I can read those settings into the `extraConfig`
specifically for the plugin in `tmux.nix`.

### popup
This capability is provided by the [tmux-floax][gh-tmux-floax] plugin, from the same author as the dotfiles.


_____________
[yt-dot-ux]: https://youtu.be/_hnuEdrM-a0
[gh-omerxx-dotfiles]: https://github.com/omerxx/dotfiles/blob/master/tmux/tmux.conf
[gh-tmux-floax]: https://github.com/omerxx/tmux-floax

