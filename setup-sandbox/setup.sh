# determinate nix install
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# build
nix build .#darwinConfigurations.<hostname>.system
sudo ./result/sw/bin/darwin-rebuild switch --flake .

# install dev tools via nix
nix develop -c "$SHELL"
# brew install direnv
# direnv allow

