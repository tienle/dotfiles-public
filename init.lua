-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader keys before lazy
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- Load core settings
require("config.options")
require("config.autocmds")

-- Setup lazy.nvim
require("lazy").setup("plugins", {
  change_detection = {
    notify = false,
  },
  rocks = {
    enabled = false, -- Disable luarocks integration if not installed
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Load keymaps after plugins
require("config.keymaps")

-- Set colorscheme (with fallback)
vim.defer_fn(function()
  -- Change this to your preferred colorscheme:
  -- "github_light" - Classic GitHub.com light theme
  -- "github_dark" - GitHub dark theme
  -- "github_dark_dimmed" - Softer dark theme
  local colorscheme = "github_dark_tritanopia"
  local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
  if not ok then
    vim.notify("Colorscheme " .. colorscheme .. " not found, falling back to default", vim.log.levels.WARN)
    vim.cmd("colorscheme default")
  end
end, 0)
