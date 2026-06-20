#!/usr/bin/env bash
# agent-dashboard.sh — live view of every Claude Code agent across tmux windows
# and sessions, with jump-to-agent. State is the @agent window option set by the
# tmux-agent-status plugin hooks (working/wait/done). tmux IS the database:
# a closed window simply drops out of the list — nothing to store or clean up.
#
# Use from a tmux popup (see bind in .tmux.conf):
#   bind a display-popup -E -w 80% -h 80% "~/.config/tmux/agent-dashboard.sh"
#
# Note: your pane-focus-in hook clears @agent (wait/done) on the focused window,
# so the dashboard naturally shows the OTHER agents that need you, not the one
# you're already looking at.
set -u

# Resolve this script's real path so fzf's reload binding can re-invoke it.
self="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

enumerate() {
  # Parse on Unit Separator (\x1f), NOT tab: tab is IFS-whitespace, so `read`
  # would collapse the empty field of an unset @agent and misalign columns.
  local US=$'\x1f'
  tmux list-windows -a -F \
    "#{session_name}${US}#{window_index}${US}#{@agent}${US}#{pane_current_path}" 2>/dev/null \
  | while IFS="$US" read -r sess win agent path; do
      [ -n "$agent" ] || continue
      case "$agent" in
        working) icon=$'\033[34m🤖\033[0m' ;;
        wait)    icon=$'\033[33m💬\033[0m' ;;
        done)    icon=$'\033[32m✅\033[0m' ;;
        *)       icon='· ' ;;
      esac
      proj="$(basename "$path")"; branch='-'; wt=' '
      if top="$(git -C "$path" rev-parse --show-toplevel 2>/dev/null)"; then
        proj="$(basename "$top")"
        branch="$(git -C "$path" rev-parse --abbrev-ref HEAD 2>/dev/null || echo '-')"
        case "$(git -C "$path" rev-parse --git-common-dir 2>/dev/null)" in
          */worktrees/*) wt='⑂' ;;
        esac
      fi
      # field 1 (hidden) = jump target; field 2 = display row
      printf '%s\t%s  %-22s %s %-26s %s\n' \
        "$sess:$win" "$icon" "$proj" "$wt" "$branch" "$sess:$win"
    done
}

case "${1:-}" in
  --enumerate) enumerate; exit 0 ;;
  --plain)     enumerate | sed $'s/\t/  /'; exit 0 ;;   # for a `watch`-based fallback
esac

sel="$(enumerate | fzf --ansi --delimiter=$'\t' \
  --with-nth=2.. --accept-nth=1 \
  --no-sort --reverse --cycle \
  --header='enter: jump   ·   ctrl-r: refresh   ·   esc: close' \
  --preview 'tmux capture-pane -ep -t {1} 2>/dev/null | tail -n 50' \
  --preview-window='down,45%,wrap' \
  --bind "load:reload-sync(sleep 1; \"$self\" --enumerate)" \
  --bind "ctrl-r:reload(\"$self\" --enumerate)")" || exit 0

[ -n "$sel" ] || exit 0
tmux switch-client -t "${sel%%:*}" 2>/dev/null
tmux select-window -t "$sel" 2>/dev/null
