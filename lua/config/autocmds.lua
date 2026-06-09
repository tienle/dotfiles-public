-- Loaded automatically by LazyVim. LazyVim already provides: restore cursor
-- position, highlight on yank, auto-create dirs on save, close-with-q for help/
-- qf/etc, wrap+spell for text filetypes, and more. Only our additions here.
local augroup = vim.api.nvim_create_augroup("user_autocmds", { clear = true })

-- ── Agent-friendly: reload buffers edited on disk by external tools ──────────
-- Pairs with `autoread`. checktime triggers FileChangedShell* and reloads if
-- the buffer is unmodified, so Claude Code edits in tmux show up instantly.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermClose", "TermLeave" }, {
  group = augroup,
  desc = "Check for external file changes",
  callback = function()
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = augroup,
  desc = "Notify when a buffer was reloaded from disk",
  callback = function()
    vim.notify("File changed on disk — buffer reloaded", vim.log.levels.WARN, { title = "autoread" })
  end,
})

-- ── Ruby filetype detection for Rails-y files without .rb extension ──────────
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup,
  pattern = { "Gemfile", "Rakefile", "Thorfile", "config.ru", "Vagrantfile", "Guardfile", "Capfile", "*.jbuilder", "*.god" },
  desc = "Treat Rails-y files as Ruby",
  command = "setfiletype ruby",
})
