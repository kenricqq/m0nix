{ pkgs, ... }:

{
  fonts.packages = with pkgs.nerd-fonts; [
    _0xproto
    _3270
    commit-mono
    commit-mono
    dejavu-sans-mono
    iosevka-term-slab
    jetbrains-mono
    monaspace
    monofur
    shure-tech-mono
    space-mono
    terminess-ttf
    tinos
    ubuntu-mono
    victor-mono
    zed-mono
  ];
}
