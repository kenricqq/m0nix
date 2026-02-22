{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # silicon # Create beautiful image of your source code
    # asciinema_3 # record terminal session
    # vhs # generate gifs with code

    chafa # convert img/GIF to Unicode, display in terminal
    onefetch # git repo
    cbonsai
    # rust-stakeholder # troll: impressive-looking nonsense terminal output

    macchina
    # asciiquarium-transparent
    # cowsay
    # ponysay
    # fortune
    # lolcat
    ### combo (ie fortune | ponysay | lolcat)
  ];
}
