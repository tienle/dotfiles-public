# Shared shell helpers — sourced from ~/.zshrc, version-controlled here.
#
# IMPORTANT: keep this file free of secrets — no tokens, keys, credentials, or
# private env. It lives in a PUBLIC repo. Anything machine- or account-specific
# stays in ~/.zshrc (which is NOT tracked).

# Claude Code under a separate config dir (the ~/.claude-tl profile).
# $HOME (not ~) so the path expands inside the env-assignment argument.
alias ccode='env CLAUDE_CONFIG_DIR=$HOME/.claude-tl claude'

# tmux attach — quick reconnect, handy from the phone (Terminus over SSH):
#   ta          reattach the most-recent session
#   ta <name>   attach a specific session (e.g. `ta fun-0`)
ta() {
  if [ -n "$1" ]; then
    tmux attach-session -t "$1"
  else
    tmux attach-session
  fi
}

# Machine-local config / secrets (tokens, keys, private env) — NEVER committed.
# Lives in $HOME, OUTSIDE the dotfiles tree (so it can't land in the repo via the
# stowed ~/.config/zsh symlink). Create ~/.zsh.local per machine as needed.
[ -f "$HOME/.zsh.local" ] && source "$HOME/.zsh.local"
