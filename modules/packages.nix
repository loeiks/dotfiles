{
  lib,
  pkgs,
  ...
}:

let
isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
t3-code = pkgs.callPackage ./packages/t3-code/stable.nix { };
in

{
  home.packages = [
    pkgs.zinit
    pkgs.oh-my-posh
    pkgs.neovim
    pkgs.tmux
    pkgs.github-cli
    pkgs.google-cloud-sdk
    pkgs.pnpm
    pkgs.yt-dlp
    pkgs.tree
    pkgs.fzf
    pkgs.ollama
    pkgs.ookla-speedtest
  ] ++ lib.optionals (!isDarwin) [
    t3-code
    pkgs.xclip
    pkgs.wsl2-ssh-agent
    pkgs.socat
  ];
}
