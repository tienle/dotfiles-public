-- Loaded automatically by LazyVim AFTER its own keymaps, so anything here wins
-- on collision. Leader is <Space> (LazyVim). Comma is free again, so the old
-- ",-layer" is preserved verbatim below, and bare "," keeps its native
-- repeat-find-backwards behaviour.
local map = vim.keymap.set

-- ══ Editing reflexes (non-leader muscle memory) ═════════════════════════════
map("n", "Y", "y$", { desc = "Yank to end of line" })
map("n", "0", "^", { desc = "First non-blank" })
map("n", "^", "0", { desc = "Hard start of line" })
map("n", "'", "`", { desc = "Jump to mark (exact)" })
map("n", "`", "'", { desc = "Jump to mark (line)" })

-- Move by display lines
map({ "n", "x" }, "j", "gj", { desc = "Down (display line)" })
map({ "n", "x" }, "k", "gk", { desc = "Up (display line)" })
map({ "n", "x" }, "$", "g$", { desc = "End of display line" })

-- Quick escape from insert
map("i", "jj", "<Esc>", { desc = "Exit insert" })
map("i", "jk", "<Esc>", { desc = "Exit insert" })
map("i", "<C-a>", "<Esc>wa", { desc = "Jump to next word (insert)" })

-- Visual indent keeps selection
map("x", "<", "<gv", { desc = "Indent left, reselect" })
map("x", ">", ">gv", { desc = "Indent right, reselect" })

-- Esc clears search highlight
map("n", "<Esc>", "<cmd>noh<cr><Esc>", { desc = "Clear search highlight" })

-- Insert dir of current file on the command line
map("c", "<C-F>", "<C-R>=expand('%:p:h')<CR>", { desc = "Insert current dir" })

-- ══ The comma layer (ported; comma is no longer the leader) ═════════════════
map("n", ",vv", "<C-w>v", { desc = "Vertical split", silent = true })
map("n", ",ss", "<C-w>s", { desc = "Horizontal split", silent = true })
map("n", ",nt", "<cmd>Neotree toggle<cr>", { desc = "Toggle file tree", silent = true })
map("n", ",.", "'.", { desc = "Jump to last change" })
map("n", ",qc", "<cmd>cclose<cr>", { desc = "Close quickfix", silent = true })
map("n", ",qo", "<cmd>copen<cr>", { desc = "Open quickfix", silent = true })

-- Quick quote surround (plugin-free, keeps old ,"/,' habit)
map("n", ',"', 'viwc"<C-r>""<Esc>', { desc = 'Quote word with "' })
map("n", ",'", "viwc'<C-r>\"'<Esc>", { desc = "Quote word with '" })
map("x", ',"', 'c"<C-r>""<Esc>', { desc = 'Quote selection with "' })
map("x", ",'", "c'<C-r>\"'<Esc>", { desc = "Quote selection with '" })

-- ══ tmux-aware window navigation (overrides LazyVim's <C-hjkl>) ═════════════
-- vim-tmux-navigator jumps across nvim splits AND tmux panes (the tmux side is
-- already configured in ~/.tmux.conf).
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Go to left window/tmux pane" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Go to lower window/tmux pane" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Go to upper window/tmux pane" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Go to right window/tmux pane" })

-- Inline replace word under cursor (your old ",S"; <leader>sr = project-wide grug-far)
map("n", ",S", [[*:%s/\<<C-r><C-w>\>//g<Left><Left>]], { desc = "Replace word in file" })
map("x", ",S", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { desc = "Replace word in file" })
