{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    commandLineArgs = [
      "--enable-logging=stderr"
    ];
    extensions = [
      { id = "cmedhionkhpnakcndndgjdbohmhepckk"; } # adblock for yt
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
      { id = "pbanhockgagggenencehbnadejlgchfc"; } # simplify copilot
      { id = "cfhdojbkjhnklbpkdaibdccddilifddb"; } # adblock plus
      { id = "nffaoalbilbmmfgbnbgppjihopabppdk"; } # video speed controller
      { id = "fjcldmjmjhkklehbacihaiopjklihlgg"; } # news feed eradicator
    ];
  };
}
