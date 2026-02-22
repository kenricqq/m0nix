A zellij session manager with zoxide integration, inspired by tmux-sesh by Josh Medeski.

## Features

- List active zellij sessions
- Create and connect to sessions based on zoxide
- Smart session detection and management
- Clone git repositories and set up sessions
- Connect to the last used session (WIP)

```sh
# 🔗 Connect to a specific session or directory
zesh connect <name>
zesh cn <name>

# 📋 List active sessions (intended to be used with other cli tools, like fzf)
zesh list
zesh l

# Pair the two commands with fzf
zesh cn $(zesh l | fzf)

# 📦 Clone a git repo and create a session
zesh clone https://github.com/username/repo
zesh cl https://github.com/username/repo

# 📂 Show the root directory of the current session (WIP)
zesh root
zesh r

# 👁️ Preview a session or directory (WIP)
zesh preview <name>
zesh p <name>

# ❓ Display help
zesh help
zesh h
```
