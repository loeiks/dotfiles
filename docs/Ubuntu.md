# Ubuntu Profile Setup

I use either native Ubuntu or via WSL2, Ubuntu is my primary way to handle all of my development (I also use macOS but its Unix as well) work as well as some non-dev work to make things easier to customize or do at all.

For example downloading videos from social platforms via `yt-dlp` is way easier via Ubuntu (or probably any Linux distro) with few simple function.

The main idea is not Ubuntu its "Linux", I use Windows for two primary area: Gaming and Creative work (and general use, although I use any OS for general use).

This documentation will explain how I do setup my environment and which tools etc. I want ready on my environment;

## Shell, Editor and Basics

I use vim mode for shell prompt, and `zsh` is my pick with the combination of `zinit`, I was using `bash` before but I switched to `zsh` mostly due to better and more advanced auto completion etc.

For the editing files, I use `nvim`, to be honest I'm still getting use to it more and more in mostly at default state to learn even the basic default key bindings so I can feel more comfortable over time and find my own needs to customize my own configuration over time instead of copying something from someone else, I believe these type of things are all about preferences and should be unique to each person, or in other words you should know, or have a reason why you have that setting enabled/disabled etc.

I also use `Oh My Posh` for my prompt customization with very minimal features I believe and a Half-Life icon at the end xd (I think its the greatest touch I've ever done at any config I had).

For the terminal, I use regular Windows Terminal and Ghostty on Mac. On native Ubuntu I don't have any specific pick yet because I mostly use Ubuntu over WSL lately not directly.

> I plan to switch soon, the hard part is I cannot fully take myself into Linux because creative and gaming part isn't fully supported or performs well.

**List:**

- zsh
- zinit
- oh my posh
- nvim

## Functions and Configs (General Customization)

I usually always start with defaults on a new tool I want to use, just like how I started with bash even though I knew zsh existed but wanted to stay with bash to find reasons why I should switch. So I customize when I feel there is a need for that or it adds some value to my workflow etc.

`zsh_functions.inc`: I do have specific functions in a dedicated file to simplify things I repeat a lot, such as `mcd` function (copied from [ahmetb](https://github.com/ahmetb/dotfiles/blob/master/zsh_functions.inc)) or `dwn` which I use to download something from social platforms.

`zsh_aliases.inc`: I don't have many aliases but I do add them when I see a repeat over time and get mad about repeating it.

`.zshrc`: contains some general things not customizations mostly. I like to have specific files for specific things.

I do have configs for `nvim`, `tmux` and more as well and all of them changes over time, listed in files directory in this repo.

## Tools, Languages

And lastly here are the tools I use, or in other words want to have ready in a fresh state when I build a new instance, I add these tools to my Nix flakes when I feel they must be installed right away from the start otherwise I feel like I can install them whenever I need them, but for tools that requires (or have) customized configs I do put them directly in Nix flakes as well (not into fresh profile).

**Tools**

- tmux *
- gh
- gcloud
- bun
- pnpm
- docker
- git *
- yt-dlp
- nvim *
- opencode *
- claude *

**Languages**

- go
- node
- python

> * means has specific configs.

I don't use `nvm` because Nix handles these type of version switches via dev shells, and it's not really required in most of my cases, one version works for most.