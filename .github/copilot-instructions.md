# m1nix - Nix-Darwin + Home Manager Configuration

**ALWAYS follow these instructions first and only fallback to additional search and context gathering if the information here is incomplete or found to be in error.**

This is a Nix-Darwin configuration repository for Apple Silicon M1 MacBook Air that manages system configuration, user environment, and dotfiles using Nix flakes, Darwin, and Home Manager.

## Working Effectively

### Prerequisites and Installation
**CRITICAL**: Install Nix with flakes support before attempting to build:
```bash
# Install Nix (Determinate Systems installer recommended for flakes)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
# Source the nix environment
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### Building and Deploying Configuration
**NEVER CANCEL BUILDS**: Initial builds take 45-60 minutes. Set timeouts to 90+ minutes.

Navigate to repository root first:
```bash
cd /path/to/m1nix
```

**Primary build command** (applies both Darwin and Home Manager):
```bash
sudo darwin-rebuild switch --flake .
```
- NEVER CANCEL: Takes 45-60 minutes on first run, 10-15 minutes on subsequent runs
- Set timeout to 90+ minutes minimum
- Requires sudo for system-level changes

**Alternative build command** (using nh tool, if available):
```bash
nh darwin switch .
```
- Slightly faster, provides better output formatting
- Still takes 30-45 minutes on first run

**Impure build** (when needed for certain packages):
```bash
sudo darwin-rebuild switch --flake . --impure
```

### Key Build Aliases (when working within the configured system)
After successful deployment, these aliases become available:
- `dhm` - Standard darwin-rebuild switch
- `dhmp` - Darwin-rebuild with --impure flag  
- `ndr` - Uses nh tool with notification when complete
- `darling` - Full rebuild + backup + cleanup (takes 60+ minutes)

### Validation Steps
**ALWAYS validate your changes with these steps after any modification:**

1. **Syntax validation**:
   ```bash
   nix flake check
   ```
   - Takes 2-5 minutes
   - Catches syntax errors before attempting build

2. **Test configuration parsing**:
   ```bash
   nix eval .#darwinConfigurations."Kenrics-MacBook-Air".system
   ```
   - Should output the system architecture string
   - Validates flake structure

3. **Verify Home Manager configuration**:
   ```bash
   home-manager switch --flake .
   ```
   - Takes 5-10 minutes
   - Tests user environment separately

4. **Manual validation scenarios** - ALWAYS run these after changes:
   - Check shell environment: `source ~/.zshrc` then test `echo $EDITOR` (should show 'hx')
   - Verify key aliases work: `dhm`, `j` (just), `z` (zoxide), `cl` (clear)
   - Test Homebrew applications: `brew list | grep -E "(ollama|aerospace|wezterm)"`
   - Verify dotfiles are linked: `ls -la ~/.config/sketchybar ~/.config/aerospace`
   - Check development tools: `go version`, `python3 --version`, `hx --version`
   - Test git configuration: `git config --get user.name` and delta diff preview

### Maintenance Commands
```bash
# Cleanup old generations and optimize store (takes 10-15 minutes)
sudo nix-collect-garbage -d
nix store optimise

# Update flake inputs (takes 5-10 minutes)
nix flake update

# Check system status
darwin-rebuild --list-generations
```

## Key Packages and Tools

### Development Tools (home-manager/dev-tools.nix)
- **Languages**: Go, Python 3.13, Rust (via rustup), Bun, Zig
- **Git Tools**: git with delta diffs, lazygit TUI, gh CLI, tig, onefetch
- **Docker/K8s**: docker-cli, lazydocker, k9s, helm, minikube
- **Databases**: sqlite, postgresql, litecli, lazysql, sqlc
- **Cloud**: awscli, google-cloud-sdk, cloudflared

### CLI Tools (home-manager/cli-tools.nix)
- **Navigation**: fzf, zoxide, broot, eza (ls replacement)
- **Search**: ripgrep, fd, television fuzzy finder
- **Monitoring**: btop, macmon (Apple Silicon performance)
- **Text Processing**: jq, yq-go, sttr, serpl, pandoc
- **Terminal**: atuin (shell history), carapace (completions)

### Homebrew Applications (darwin/homebrew.nix)
- **Development**: VSCode, Zed, Wezterm, Ghostty, OrbStack
- **Productivity**: Aerospace (window manager), Raycast, Linear
- **Security**: Lulu firewall, Oversight, Reikey, Secretive
- **AI Tools**: ChatGPT, Claude, Ollama (local LLMs)

## Repository Structure
### Core Configuration Files
- `flake.nix` - Main entry point defining the system configuration
- `darwin/homebrew.nix` - Homebrew package definitions  
- `darwin/system.nix` - macOS system settings
- `home-manager/home.nix` - Main user environment configuration
- `home-manager/alias.nix` - Shell aliases and shortcuts
- `secrets.yaml` - Encrypted secrets using sops-nix

### Key Directories
- `darwin/` - System configuration (requires sudo to apply)
- `home-manager/` - User environment and dotfiles
- `home-manager/_apps/` - Application-specific configurations
- `home-manager/dotfiles/` - Symlinked configuration files
- `home-manager/scripts/` - Utility scripts

### Package Configuration Files
- `home-manager/cli-tools.nix` - Command-line tools (btop, fzf, ripgrep, jq, etc.)
- `home-manager/dev-tools.nix` - Development tools (git, gh, docker, k9s, lazygit, ruff)
- `home-manager/helix.nix` - Helix editor configuration
- `home-manager/wezterm.nix` - Terminal emulator configuration
- `home-manager/zsh.nix` - Shell configuration and plugins

## Common Commands and Aliases

### Frequently Used Aliases (from home-manager/alias.nix)
After successful deployment, these productivity aliases are available:

**Navigation and File Management:**
- `z <path>` - Smart directory jumping (zoxide)
- `zi` - Interactive directory picker
- `root` - Jump to git repository root
- `cl` - Clear terminal
- `fff` - Show system info with fastfetch

**Development Workflow:**
- `j <target>` - Run just commands (project task runner)
- `ma` / `mf` / `mc` - Make commands (all/format/clean)
- `venv` - Activate Python virtual environment in current git repo

**System Management:**
- `dhm` - Rebuild Darwin configuration (sudo darwin-rebuild switch --flake .)
- `dhmp` - Rebuild with --impure flag for troublesome packages
- `ndr` - Rebuild using nh tool with completion notification
- `darling` - Full rebuild + backup + cleanup (60+ minutes)

**Editing and Configuration:**
- `snip` - Edit code snippets collection
- `links` - Edit golinks.yaml bookmark file
- `zu` / `ku` - Edit utility scripts and keyboard configuration

**Media and Tools:**
- `music` - Start MPD and launch rmpc music client
- `t` - Launch tgpt AI chat interface
- `olr` - Launch Ollama local LLM interface

## Common Development Tasks
1. **For command-line tools**: Add to `home-manager/cli-tools.nix` packages list
2. **For development tools**: Add to `home-manager/dev-tools.nix` programs section
3. **For GUI applications**: Add to `darwin/homebrew.nix` casks section
4. **For system services**: Add to `darwin/homebrew.nix` brews section
5. **Always rebuild and test** after adding packages: `sudo darwin-rebuild switch --flake .`

### Adding New Packages
1. **Terminal/shell tools**: Often auto-configured via programs.* in relevant .nix files
2. **Dotfiles**: Place config files in `home-manager/dotfiles/` and link in `home.nix`
3. **Application settings**: Use programs.* sections in appropriate .nix modules

### Modifying Dotfiles
1. Edit files in `home-manager/dotfiles/`
2. Check that symlinks are properly defined in `home.nix`
3. Test with `home-manager switch --flake .`

### Sketchybar Helper Compilation
The repository includes C helper binaries for sketchybar that need compilation:
```bash
# Navigate to sketchybar bridge directory
cd home-manager/dotfiles/sketchybar/bridge
make all
```
- Compiles `network_load` and `menus` helper binaries
- Uses clang with macOS-specific frameworks (Carbon, SkyLight)
- NEVER CANCEL: Compilation takes 2-5 minutes
- Required for sketchybar functionality if using that configuration
### Secret Management
2. Add new secrets to the sops configuration
3. Reference in configuration files using `config.sops.secrets.<name>.path`

### Common Issues and Solutions
- **Build fails with "file not found"**: Check file paths are absolute and exist
- **Permission denied**: Ensure using `sudo` for `darwin-rebuild` commands
- **Homebrew conflicts**: Use `brew cleanup` and retry build
- **Secret decryption fails**: Ensure age key is properly configured

## Timing Expectations
- **Initial clone and build**: 60-90 minutes (NEVER CANCEL)
- **Subsequent builds**: 10-20 minutes  
- **Home Manager only**: 5-10 minutes
- **Flake updates**: 5-15 minutes
- **Garbage collection**: 10-15 minutes
- **Full rebuild with cleanup**: 60+ minutes

**CRITICAL**: Always set command timeouts to at least double these estimates. Commands may appear to hang but are often downloading packages or compiling software.

## Environment Variables and Paths
After successful deployment, these variables are available:
- `$EDITOR` - Set to 'hx' (Helix editor)
- `$NX` - Points to `~/.config/nix`  
- `$HM` - Points to `~/.config/nix/home-manager`
- `$DW` - Points to `~/.config/nix/darwin`
- `$DOT` - Points to dotfiles directory
- `$SCRIPTS` - Points to scripts directory

## Troubleshooting
1. **Always check flake syntax first**: `nix flake check`
2. **Verify Nix daemon is running**: `sudo launchctl list | grep nix`
3. **Check available disk space**: Nix builds require substantial temporary space
4. **Review logs**: `journalctl -u nix-daemon` or check `/var/log/`
5. **Reset if corrupted**: `sudo nix-store --verify --check-contents --repair`

## Testing Changes
**ALWAYS test configuration changes before committing:**
1. Run `nix flake check` to validate syntax
2. Build configuration with `darwin-rebuild switch --flake .`
3. Test affected functionality manually
4. Verify no regressions in existing aliases and tools
5. Check that secrets are properly decrypted if modified

Remember: This configuration manages the entire system environment. Take time to validate changes thoroughly as they affect the complete user experience.