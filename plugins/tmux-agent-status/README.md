# tmux-agent-status

Surface what your Claude Code agents are doing across many worktrees/projects.
Hooks write one piece of state — the `@agent` tmux window option
(`working`/`wait`/`done`) — and **three consumers** read it. No daemon, no
database: tmux holds the state, so a closed window just disappears.

```
                       ┌──► tmux pill        🤖 working / 💬 waiting / ✅ done   (tmux/.tmux.conf)
  hooks set @agent ────┼──► Telegram         ping when a BACKGROUND agent finishes / needs input
   = the ONE writer    └──► dashboard        prefix+A: agents grouped by state (💬→🤖→✅), enter = jump
                            ▲
         "tmux IS the database" — liveness is free, nothing to clean up
```

## Components

| Piece | Lives in | What it does |
|-------|----------|--------------|
| Hooks | this plugin (`hooks/hooks.json` → `scripts/tmux-agent.sh`) | set `@agent` on UserPromptSubmit/PostToolUse (working), Notification permission/elicitation (wait), Stop (done) |
| Pill | `tmux/.tmux.conf` (`window-status-format`) | renders `@agent` as 🤖/💬/✅; the window you're ON omits 💬/✅ via `current-format` (no nag) but `@agent` is never erased, so state persists for the dashboard |
| Telegram | this plugin (`scripts/notify-telegram.sh`) | **optional**, no-op unless configured; pings on Stop/permission for windows you're *not* watching |
| Dashboard | `tmux/.config/tmux/agent-dashboard.sh` + `prefix+A` bind | fzf popup, agents grouped by state (💬 waiting → 🤖 working → ✅ done) with per-group counts, live-refresh, `enter` jumps to it |

## Install (any machine)

```sh
# 1. tmux rendering + dashboard
stow tmux                                   # links ~/.tmux.conf and ~/.config/tmux/

# 2. the hooks (this plugin)
claude plugin marketplace add tienle/dotfiles-public
claude plugin install tmux-agent-status@tienle-dotfiles
#   then /reload-plugins (or restart Claude Code)

# 3. (optional) Telegram alerts — token stays OUT of git
mkdir -p ~/.config/claude
cp telegram.env.example ~/.config/claude/telegram.env   # from this plugin dir
chmod 600 ~/.config/claude/telegram.env
$EDITOR ~/.config/claude/telegram.env                   # paste bot token + chat_id
```

Get a bot token from **@BotFather** (`/newbot`); get your `chat_id` by messaging
the bot once then:
`curl -s "https://api.telegram.org/bot<TOKEN>/getUpdates" | jq '.result[].message.chat.id'`.

## Telegram trigger policy

Pings only for an agent in a window you are **not** currently watching, on:
- **Stop** — the agent finished its turn (your "your turn" signal), and
- **Notification** of type `permission_prompt` / `elicitation_dialog` — it's blocked on you.

Stays silent for the window you're focused on, for idle-notification noise, and
when not configured. A 5s per-window dedup guard prevents bursts. The network
call is backgrounded with hard timeouts, so it never stalls the agent.

Known limitation: `AskUserQuestion` does not emit a Notification (Claude Code
gap), so those questions won't ping.

## Requirements

tmux ≥ 3.2 (popups), `jq`, `curl`, `fzf`, `git`; Claude Code running inside a
tmux pane (`$TMUX_PANE`). Everything no-ops gracefully outside tmux.

## Later: a richer dashboard

The dashboard is a pure *reader* of tmux state, so it can be swapped for a
custom TUI (e.g. a Rust/ratatui `agentctl dashboard`) with zero changes to the
hooks, Telegram, or pill — it would read the same `tmux list-windows` and issue
the same `select-window` jump.
