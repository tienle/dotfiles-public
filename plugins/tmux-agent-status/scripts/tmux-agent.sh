#!/usr/bin/env bash
# tmux-agent.sh <state>   —   state = working | wait | done
#
# Sets the @agent window option on the tmux window running this Claude Code
# session, so ~/.tmux.conf can render a status pill:
#   working -> 🤖   wait -> 💬 (needs you)   done -> ✅
#
# Invoked by this plugin's hooks (UserPromptSubmit/PostToolUse -> working,
# Notification -> wait, Stop -> done). 'wait' never downgrades a finished
# 'done', so an idle notification won't flip ✅ back to 💬. Focusing the
# window clears wait/done via a pane-focus-in hook in tmux.conf.
set -u
state="${1:-}"

# Not inside tmux (TMUX_PANE unset) -> nothing to render, exit quietly.
[ -n "${TMUX_PANE:-}" ] || exit 0

# Don't let a mid-task "waiting for input" ping overwrite a finished turn.
if [ "$state" = wait ]; then
  cur=$(tmux show -wqv -t "$TMUX_PANE" @agent 2>/dev/null || true)
  [ "$cur" = done ] && exit 0
fi

tmux set -w -t "$TMUX_PANE" @agent "$state" 2>/dev/null || true
