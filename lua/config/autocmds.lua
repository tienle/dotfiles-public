local augroup = vim.api.nvim_create_augroup("MyAutoCommands", { clear = true })

-- Remember last location in file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= "gitcommit" and vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd("normal! g`\"")
    end
  end,
  desc = "Remember cursor position",
})

-- Set Ruby filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup,
  pattern = { "Gemfile", "Rakefile", "Thorfile", "config.ru", "Vagrantfile", "Guardfile", "Capfile" },
  command = "set ft=ruby",
  desc = "Set Ruby filetype for Ruby files",
})

-- Reload config on save
vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup,
  pattern = { "init.lua", "*/lua/config/*.lua", "*/lua/plugins/*.lua" },
  callback = function()
    vim.cmd("source %")
    vim.notify("Config reloaded", vim.log.levels.INFO)
  end,
  desc = "Reload config on save",
})

-- File-specific abbreviations
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "reason",
  callback = function()
    vim.cmd("iabbrev <buffer> rer ReasonReact")
    vim.cmd("iabbrev <buffer> tp type")
  end,
  desc = "Reason abbreviations",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
  desc = "Highlight yanked text",
})

-- Terminal settings
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd("startinsert")
  end,
  desc = "Terminal settings",
})
