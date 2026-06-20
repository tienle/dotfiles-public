#!/usr/bin/env bash
# agent-dashboard.sh — live view of every Claude Code agent across tmux windows
# and sessions, grouped by state and sorted 💬 waiting → 🤖 working → ✅ done,
# with jump-to-agent. State is the @agent window option set by the
# tmux-agent-status plugin hooks. tmux IS the database: a closed window simply
# drops out of the list — nothing to store or clean up.
#
# Use from a tmux popup (see bind in .tmux.conf):
#   bind A display-popup -E -w 80% -h 80% "~/.config/tmux/agent-dashboard.sh"
#
# Note: your pane-focus-in hook clears @agent (wait/done) on the focused window,
# so the dashboard shows the OTHER agents that need you, not the one you're on.
set -u

# Resolve this script's real path so fzf's reload binding can re-invoke it.
self="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

# Per-agent rows, tab-separated: PRIO \t TARGET \t DISPLAY
# PRIO orders the groups: 0=waiting, 1=working, 2=done, 3=other.
enumerate_raw() {
  # Parse on Unit Separator (\x1f), NOT tab: tab is IFS-whitespace, so `read`
  # would collapse the empty field of an unset @agent and misalign columns.
  local US=$'\x1f'
  tmux list-windows -a -F \
    "#{session_name}${US}#{window_index}${US}#{@agent}${US}#{pane_current_path}" 2>/dev/null \
  | while IFS="$US" read -r sess win agent path; do
      [ -n "$agent" ] || continue
      case "$agent" in
        wait)    prio=0; icon=$'\033[33m💬\033[0m' ;;
        working) prio=1; icon=$'\033[34m🤖\033[0m' ;;
        done)    prio=2; icon=$'\033[32m✅\033[0m' ;;
        *)       prio=3; icon='· ' ;;
      esac
      proj="$(basename "$path")"; branch='-'; wt=' '
      if top="$(git -C "$path" rev-parse --show-toplevel 2>/dev/null)"; then
        proj="$(basename "$top")"
        branch="$(git -C "$path" rev-parse --abbrev-ref HEAD 2>/dev/null || echo '-')"
        case "$(git -C "$path" rev-parse --git-common-dir 2>/dev/null)" in
          */worktrees/*) wt='⑂' ;;
        esac
      fi
      printf '%s\t%s\t%s  %-22s %s %-26s %s\n' \
        "$prio" "$sess:$win" "$icon" "$proj" "$wt" "$branch" "$sess:$win"
    done
}

# Grouped + sorted rows for fzf: TARGET \t DISPLAY, with a colored header line
# (empty target, so selecting it is a no-op) before each non-empty group.
emit_rows() {
  enumerate_raw | sort -t$'\t' -k1,1n -s | awk -F'\t' '
    { line[NR]=$0; p[NR]=$1+0; cnt[$1+0]++ }
    END {
      split("💬 WAITING|🤖 WORKING|✅ DONE|· OTHER", L, "|")
      C[0]="\033[1;33m"; C[1]="\033[1;34m"; C[2]="\033[1;32m"; C[3]="\033[1;90m"
      last=-1
      for (i=1; i<=NR; i++) {
        if (p[i] != last) { printf "\t%s%s (%d)\033[0m\n", C[p[i]], L[p[i]+1], cnt[p[i]]; last=p[i] }
        split(line[i], f, "\t"); printf "%s\t%s\n", f[2], f[3]
      }
    }'
}

case "${1:-}" in
  --rows)  emit_rows; exit 0 ;;
  --plain) emit_rows | sed $'s/\t/  /'; exit 0 ;;   # for a `watch`-based fallback
esac

sel="$("$self" --rows | fzf --ansi --delimiter=$'\t' \
  --with-nth=2.. --accept-nth=1 \
  --no-sort --reverse --cycle \
  --header='enter: jump   ·   ctrl-r: refresh   ·   esc: close' \
  --preview 'tmux capture-pane -ep -t {1} 2>/dev/null | tail -n 50' \
  --preview-window='down,45%,wrap' \
  --bind "load:reload-sync(sleep 1; \"$self\" --rows)" \
  --bind "ctrl-r:reload(\"$self\" --rows)")" || exit 0

[ -n "$sel" ] || exit 0          # header rows have an empty target -> no-op
tmux switch-client -t "${sel%%:*}" 2>/dev/null
tmux select-window -t "$sel" 2>/dev/null
