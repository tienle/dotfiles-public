# tmux-agent-status

A Claude Code plugin that surfaces the coding agent's state in the **tmux
window pill**, so you can tell at a glance which window is busy, blocked, or
done — across many parallel sessions.

```
🤖  working   — agent is processing (blue pill)
💬  waiting   — agent paused for you: a question or permission (amber pill)
✅  done      — agent finished its turn (green pill)
```

Focusing a window clears 💬 / ✅; a still-running 🤖 survives.

## How it works

Two halves, split so neither touches anything secret:

```
 this plugin (hooks)                 tmux/.tmux.conf (rendering)
 ───────────────────                 ──────────────────────────
 UserPromptSubmit ┐                  window-status-format reads the
 PostToolUse      ├─ scripts/        @agent option and draws the pill;
 Notification     │  tmux-agent.sh   pane-focus-in clears wait/done.
 Stop             ┘  sets @agent
                       │
                       └─► tmux set -w @agent <state>  (on $TMUX_PANE's window)
```

The hooks live here (version-controlled, portable) instead of in
`~/.claude/settings.json`, so settings.json never has to be tracked. Plugin
hooks **merge** with your existing hooks — installing this never overwrites
your config. `Notification` won't downgrade a finished `done` (an idle ping
won't flip ✅ back to 💬).

## Install (any machine)

The tmux rendering ships in this repo's `tmux/.tmux.conf`, so first put that in
place (`stow tmux`, or your usual method). Then enable the plugin:

```sh
claude plugin marketplace add tienle/dotfiles-public   # or a local clone path
claude plugin install tmux-agent-status@tienle-dotfiles
```

Restart Claude Code (or `/reload-plugins`). New sessions launched inside tmux
will drive the window pill. Outside tmux the hooks no-op safely.

## Requirements

- tmux, with the `window-status-format` / `pane-focus-in` config from
  `tmux/.tmux.conf` in this repo (keys off the `@agent` window option).
- Claude Code running inside a tmux pane (`$TMUX_PANE` set).
