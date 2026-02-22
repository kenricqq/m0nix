{ pkgs, ... }:

{
  fonts.packages =
    with pkgs.nerd-fonts;
    [
      _0xproto
      iosevka-term-slab
      monofur
      shure-tech-mono # reminds me of video games
      space-mono
      symbols-only
      victor-mono # thin chars
      zed-mono # similar to Iosevka, without serif
    ]
    ++ (with pkgs; [
      maple-mono.NF-CN-unhinted # top 1 mono
      maple-mono.Normal-NF-CN-unhinted
      inter
      dm-sans
      dm-mono
      eb-garamond # top 1 serif
      source-code-pro
      source-sans
      source-serif # top 2 serif
      work-sans
    ]);
}

## Extras (with pkgs.nerd-fonts) ##
# terminess-ttf # arcade game vibes
# tinos # serif nerd font, hmm...
# _3270 # serif nerd font
# dejavu-sans-mono
# jetbrains-mono
# monaspace
# ubuntu-mono
