-- Loaded automatically by LazyVim before plugins start.
-- LazyVim already sets many sane defaults (termguicolors, ignorecase/smartcase,
-- splitkeep, signcolumn, undofile, scrolloff, etc.). Only personal deltas here.
local opt = vim.opt

-- Line numbers OFF (personal preference, ported from old config)
opt.number = false
opt.relativenumber = false

-- Indentation: 2-space soft tabs (fits Ruby/JS/TS/Lua; rust/go use their own)
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.expandtab = true

-- Show whitespace
opt.list = true
opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }

-- No swap/backup; keep persistent undo (Neovim stores undo in stdpath('state'))
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true

-- Splits open down/right
opt.splitbelow = true
opt.splitright = true

-- ctags lookup (ported)
opt.tags = "./tags;,gems.tag;"

-- Agentic workflows: reload files changed on disk by external tools (Claude Code)
opt.autoread = true

-- No remote ruby/perl/python plugins — disable those providers to keep
-- :checkhealth clean (does NOT affect ruby_lsp, filetypes, or editing).
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
