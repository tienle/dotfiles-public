#!/usr/bin/env bash
# notify-telegram.sh — Telegram ping when an agent in a BACKGROUND tmux window
# needs you: it finished a turn (Stop) or is blocked on a permission /
# elicitation prompt (Notification). Stays silent for the window you're
# actively watching, so you only hear about agents elsewhere.
#
# Reads the Claude Code hook payload (JSON) on stdin. Safe no-op when:
#   - ~/.config/claude/telegram.env is missing or incomplete  (not configured)
#   - not running inside tmux ($TMUX_PANE unset)
#   - the event isn't one we notify on
#   - you're focused on this very window  (you'd see it anyway)
# Never blocks the agent: the network call is backgrounded with hard timeouts.
set -u

CONF="${HOME}/.config/claude/telegram.env"
[ -f "$CONF" ] || exit 0
# shellcheck source=/dev/null
. "$CONF"
[ -n "${TELEGRAM_BOT_TOKEN:-}" ] && [ -n "${TELEGRAM_CHAT_ID:-}" ] || exit 0
[ -n "${TMUX_PANE:-}" ] || exit 0

# Read the hook payload from stdin — but only if stdin is a pipe, so a manual
# run from a terminal can't hang on cat.
payload=""
[ -t 0 ] || payload="$(cat)"
field() { printf '%s' "$payload" | jq -r "$1 // empty" 2>/dev/null; }
event="$(field .hook_event_name)"
ntype="$(field .notification_type)"
message="$(field .message)"
cwd="$(field .cwd)"
[ -n "$cwd" ] || cwd="${CLAUDE_PROJECT_DIR:-}"

# Trigger policy: finished (Stop) OR a real attention prompt.
case "$event" in
  Stop) reason="finished"; icon="✅" ;;
  Notification)
    case "$ntype" in
      permission_prompt|elicitation_dialog) reason="needs input"; icon="💬" ;;
      *) exit 0 ;;
    esac ;;
  *) exit 0 ;;
esac

# Background-only gate: skip if this is the active window of an attached session
# (i.e. you're probably looking at it). tmux does the boolean for us.
watched="$(tmux display -p -t "$TMUX_PANE" \
  '#{?#{&&:#{window_active},#{session_attached}},1,0}' 2>/dev/null || echo 0)"
[ "$watched" = 1 ] && exit 0

loc="$(tmux display -p -t "$TMUX_PANE" '#{session_name}:#{window_index}' 2>/dev/null || echo '?')"

# Dedup: at most one ping per window per 5s (Stop + a trailing Notification etc.)
key="$(printf '%s' "$loc" | tr -c 'A-Za-z0-9' _)"
stamp="${TMPDIR:-/tmp}/claude-tg-${key}"
now="$(date +%s)"
if [ -f "$stamp" ]; then
  last="$(cat "$stamp" 2>/dev/null || echo 0)"
  [ $(( now - last )) -lt 5 ] && exit 0
fi
echo "$now" > "$stamp" 2>/dev/null || true

# Build the message.
proj="-"
[ -n "$cwd" ] && proj="$(basename "$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null || echo "$cwd")")"
text="${icon} ${proj} [${loc}] — ${reason}"
[ -n "$message" ] && text="${text}
${message}"

# Plain text (no parse_mode) + jq-built JSON => arbitrary content can't break it.
body="$(jq -n --arg c "$TELEGRAM_CHAT_ID" --arg t "$text" \
        '{chat_id:$c, text:$t, disable_notification:false}')"

curl -sS -o /dev/null --connect-timeout 3 --max-time 10 --retry 1 \
     -H 'Content-Type: application/json' -d "$body" \
     "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" >/dev/null 2>&1 &
disown 2>/dev/null || true
exit 0
