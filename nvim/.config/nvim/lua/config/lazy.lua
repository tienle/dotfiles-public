-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Leader keys (space). Set before lazy so all mappings resolve correctly.
-- This matches LazyVim's default; comma is intentionally left free for the
-- ported ",-layer" maps in config/keymaps.lua.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
    -- LazyVim core. Extras are enabled via lazyvim.json (:LazyExtras).
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Our own plugins / overrides.
    { import = "plugins" },
  },
  defaults = {
    -- LazyVim plugins are lazy by default; our specs decide per-plugin.
    lazy = false,
    version = false, -- always use latest git commit
  },
  install = { colorscheme = { "github_dark_tritanopia", "tokyonight", "habamax" } },
  checker = { enabled = true, notify = false }, -- background update checks, quiet
  change_detection = { notify = false },
  rocks = { enabled = false }, -- no luarocks-based plugins; silences hererocks health error
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
