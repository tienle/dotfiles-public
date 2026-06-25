# dotfiles-public

Personal dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level directory is a Stow **package** whose contents mirror `$HOME`. The
repo also doubles as a [Claude Code plugin marketplace](#claude-code-agent-status)
(`.claude-plugin/marketplace.json`).

## Packages

| Package    | Symlinks to                       | What                                  |
| ---------- | --------------------------------- | ------------------------------------- |
| `nvim/`    | `~/.config/nvim`                  | Neovim (LazyVim distro, 0.12)         |
| `ghostty/` | `~/.config/ghostty`               | Ghostty terminal                      |
| `lazygit/` | `~/.config/lazygit`               | lazygit (delta diff) †                |
| `tmux/`    | `~/.tmux.conf`, `~/.config/tmux/` | tmux (+ agent-dashboard script)       |
| `wezterm/` | `~/.wezterm.lua`                  | WezTerm                               |
| `claude/`  | `~/.claude/CLAUDE.md`             | Claude Code global instructions       |
| `zsh/`     | `~/.config/zsh/`                  | Shared shell helpers (`ta`, `ccode`) ‡ |

† lazygit on macOS reads `~/Library/Application Support/lazygit` by default. Set
`export XDG_CONFIG_HOME="$HOME/.config"` in `~/.zshrc` so it uses the stowed
`~/.config/lazygit` instead. Requires `git-delta` (`brew install git-delta`).

‡ Only safe, non-secret helpers live here — `~/.zshrc` itself is **not** tracked
(it holds machine/account-specific config and secrets). Source the shared file
from `~/.zshrc` once per machine:
`[ -f ~/.config/zsh/aliases.zsh ] && source ~/.config/zsh/aliases.zsh`
(`ta` = quick `tmux attach`, handy from a phone; `ccode` = Claude in the
`~/.claude-tl` profile.) Per-machine secrets/env go in `~/.zsh.local` — it's
auto-sourced by `aliases.zsh`, lives outside the repo, and is gitignored.

## Install

```sh
brew install stow git-delta fzf jq      # fzf + jq power the agent dashboard/notifier
cd ~/research-repos/dotfiles-public

# Stow refuses to clobber real files — move any that already exist aside first:
for f in .config/nvim .config/ghostty .config/tmux .tmux.conf .wezterm.lua .claude/CLAUDE.md; do
  [ -e "$HOME/$f" ] && [ ! -L "$HOME/$f" ] && mv "$HOME/$f" "$HOME/$f.pre-stow"
done

# Symlink everything into place:
stow -t ~ nvim ghostty lazygit tmux wezterm claude zsh
```

For `zsh`, also add this to `~/.zshrc` (it's not tracked — see the ‡ note):
`[ -f ~/.config/zsh/aliases.zsh ] && source ~/.config/zsh/aliases.zsh`

Stow one package only: `stow -t ~ nvim`
Remove symlinks: `stow -D -t ~ nvim ghostty lazygit tmux wezterm claude zsh`
Re-sync after adding files: `stow -R -t ~ tmux`

## Claude Code: agent status

This repo is also a Claude Code plugin marketplace. The **`tmux-agent-status`**
plugin surfaces what each coding agent is doing — in your tmux status bar, a
dashboard, and (optionally) Telegram. Install it on any machine:

```sh
claude plugin marketplace add tienle/dotfiles-public
claude plugin install tmux-agent-status@tienle-dotfiles
# then /reload-plugins  (or restart Claude Code)
```

What you get (requires the `tmux` package stowed, and Claude running inside tmux):

- **Window pill** — each tmux window shows its agent's state: 🤖 working /
  💬 waiting for input / ✅ done.
- **Dashboard** — `prefix + A` opens an fzf popup listing every agent across all
  windows/sessions, grouped 💬 waiting → 🤖 working → ✅ done; `enter` jumps to
  one. It refreshes live while idle, pauses the instant you type or scroll (so
  reading stays responsive), and `ctrl-r` re-polls.
- **Telegram alerts** (optional) — ping when a *background* agent finishes or
  needs input. Keep the token OUT of git:
  ```sh
  mkdir -p ~/.config/claude
  cp plugins/tmux-agent-status/telegram.env.example ~/.config/claude/telegram.env
  chmod 600 ~/.config/claude/telegram.env   # then add your bot token + chat_id
  ```
  Without this file the notifier is a silent no-op.

See [`plugins/tmux-agent-status/README.md`](plugins/tmux-agent-status/README.md)
for how it works.

## Secrets

Claude Code config that can hold tokens is **never** tracked — `.gitignore`
blocks `**/.claude/settings.json`, `**/.claude/settings.local.json`,
`**/.claude.json`, and `**/telegram.env`. Only non-secret files (e.g.
`CLAUDE.md`, the plugin, `telegram.env.example`) live in the repo.

## Notes

- `nvim/.config/nvim/lazy-lock.json` pins plugin versions for reproducible installs.
- After stowing, configs are symlinks into this repo, so editing them in place
  commits straight here — one source of truth.
