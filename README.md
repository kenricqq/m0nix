# m0nix
Nix setup w/ Darwin + Home Manager

## setup
- to use lefthook for checking leaked secrets, make sure to `lefthook install`
- change hostname and username in `flake.nix`

### build from existing flake.nix
nix --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.$(hostname -s).system
./result/sw/bin/darwin-rebuild switch --flake .


## home-manager
- symlink setup, centralized dotfiles, no rebuild needed
- module variable
