local map = vim.keymap.set

-- Better default mappings
map("n", "Y", "y$", { desc = "Yank to end of line" })
map("n", "0", "^", { desc = "Go to first non-blank character" })
map("n", "^", "0", { desc = "Go to beginning of line" })
map("n", "'", "`", { desc = "Jump to mark" })
map("n", "`", "'", { desc = "Jump to mark line" })

-- Quotes
map("", ',"', 'ysiw"', { desc = "Surround with double quotes" })
map("v", ',"', 'c"<C-R>""<ESC>', { desc = "Surround selection with double quotes" })
map("", ",'", "ysiw'", { desc = "Surround with single quotes" })
map("v", ",'", "c'<C-R>\"'<ESC>", { desc = "Surround selection with single quotes" })

-- Navigation
map("n", ",.", "'.", { desc = "Jump to last change" })
map("i", "<C-a>", "<esc>wa", { desc = "Move to next word" })

-- Window splits
map("n", ",vv", "<C-w>v", { desc = "Vertical split", silent = true })
map("n", ",ss", "<C-w>s", { desc = "Horizontal split", silent = true })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Navigate left" })
map("n", "<C-j>", "<C-w>j", { desc = "Navigate down" })
map("n", "<C-k>", "<C-w>k", { desc = "Navigate up" })
map("n", "<C-l>", "<C-w>l", { desc = "Navigate right" })

-- Quickfix
map("n", ",qc", ":cclose<CR>", { desc = "Close quickfix", silent = true })
map("n", ",qo", ":copen<CR>", { desc = "Open quickfix", silent = true })

-- Buffer navigation
map("n", "<Leader><Leader>", "<C-^>", { desc = "Toggle buffer" })

-- Search and replace
map("n", "<leader>S", "*:%s/\\<<C-r><C-w>\\>//g<Left><Left>", { desc = "Replace word under cursor" })
map("v", "<leader>S", ":%s/\\<<C-r><C-w>\\>//g<Left><Left>", { desc = "Replace selection" })

-- Visual mode improvements
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Quick escape
map("i", "jj", "<Esc>", { desc = "Exit insert mode" })
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Better movement
map("n", "k", "gk", { desc = "Move up display line", silent = true })
map("n", "j", "gj", { desc = "Move down display line", silent = true })
map({ "n", "v" }, "0", "g0", { desc = "Move to beginning of display line", silent = true })
map({ "n", "v" }, "$", "g$", { desc = "Move to end of display line", silent = true })

-- Clear highlight
map("n", "<Esc>", ":noh<CR><Esc>", { desc = "Clear search highlight" })

-- Toggle line numbers
map("n", "<Leader>tn", ":set nonumber!<CR>", { desc = "Toggle line numbers", silent = true })

-- Save files
map("n", "<c-s>", ":w<cr>", { desc = "Save file" })
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })

-- Command line
map("c", "<C-F>", "<C-R>=expand('%:p:h')<CR>", { desc = "Insert current file path" })

-- Terminal mode mappings (will be configured per terminal plugin)

-- Diagnostic keymaps
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic message" })
map("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostic list" })
-- map("n", "gl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
