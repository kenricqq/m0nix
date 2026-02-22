```sh
## convert nix file to toml, copy to clip
nix-converter -from-nix -f test.nix -l toml | pbcopy

## convert toml to nix
nix-converter -f input.toml -l nix

## in place convert to nix from toml
<highlighted_buffer> | nix-converter -l toml
```
