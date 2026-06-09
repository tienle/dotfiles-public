# dotfiles-public

Personal dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level directory is a Stow **package** whose contents mirror `$HOME`.

## Packages

| Package    | Symlinks to         | What                          |
| ---------- | ------------------- | ----------------------------- |
| `nvim/`    | `~/.config/nvim`    | Neovim (LazyVim distro, 0.12) |
| `ghostty/` | `~/.config/ghostty` | Ghostty terminal              |
| `lazygit/` | `~/.config/lazygit` | lazygit (delta diff) †        |
| `tmux/`    | `~/.tmux.conf`      | tmux                          |
| `wezterm/` | `~/.wezterm.lua`    | WezTerm                       |

† lazygit on macOS reads `~/Library/Application Support/lazygit` by default. Set
`export XDG_CONFIG_HOME="$HOME/.config"` in `~/.zshrc` so it uses the stowed
`~/.config/lazygit` instead. Requires `git-delta` (`brew install git-delta`).

## Install

```sh
brew install stow git-delta             # if not already installed
cd ~/research-repos/dotfiles-public

# If these already exist as real files/dirs, move them aside first
# (Stow refuses to clobber non-symlinks):
mv ~/.config/nvim    ~/.config/nvim.pre-stow    2>/dev/null || true
mv ~/.config/ghostty ~/.config/ghostty.pre-stow 2>/dev/null || true
mv ~/.tmux.conf      ~/.tmux.conf.pre-stow      2>/dev/null || true
mv ~/.wezterm.lua    ~/.wezterm.lua.pre-stow    2>/dev/null || true

# Symlink everything into place:
stow -t ~ nvim ghostty lazygit tmux wezterm
```

Stow one package only: `stow -t ~ nvim`
Remove symlinks: `stow -D -t ~ nvim ghostty lazygit tmux wezterm`
Re-sync after adding files: `stow -R -t ~ nvim`

## Notes

- `nvim/.config/nvim/lazy-lock.json` pins plugin versions for reproducible installs.
- After stowing, `~/.config/nvim` is a symlink into this repo, so editing the
  config in place commits straight here — one source of truth.
