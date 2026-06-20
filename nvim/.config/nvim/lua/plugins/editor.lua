return {
  -- tmux-aware window navigation. Pairs with the christoomey/vim-tmux-navigator
  -- plugin already loaded in ~/.tmux.conf, so <C-hjkl> cross the nvim<->tmux
  -- boundary with no tmux.conf changes. Keys are bound in config/keymaps.lua.
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    init = function()
      vim.g.tmux_navigator_no_default_mappings = 1
    end,
  },

  -- Sublime-style multiple cursors (ported from old config)
  {
    "mg979/vim-visual-multi",
    keys = {
      { "<C-n>", mode = { "n", "x" }, desc = "Multicursor: select word" },
      { "<C-x>", mode = { "n", "x" }, desc = "Multicursor: skip region" },
      { ",mc", mode = { "n", "x" }, desc = "Multicursor: regex search" },
    },
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
        ["Skip Region"] = "<C-x>",
        ["Remove Region"] = "Q",
        ["Start Regex Search"] = ",mc",
      }
    end,
  },

  -- Surround: ys/cs/ds + visual S — your vim-surround muscle memory, same as
  -- your old config used. (v4 sets keymaps via its own plugin files; defaults
  -- are fine. Visual S surrounds the selection, overriding Flash's visual S.)
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },

  -- Align text on a delimiter (ga / gA), ported from old config
  {
    "nvim-mini/mini.align",
    keys = { { "ga", mode = { "n", "x" } }, { "gA", mode = { "n", "x" } } },
    opts = {},
  },

  -- Rich diff/merge/file-history view — ideal for reviewing changesets that
  -- Claude Code (or anyone) made on disk.
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diff View (working tree)" },
      { "<leader>gV", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (current file)" },
    },
    opts = {},
  },

  -- Fugitive for power git commands (:Git, :G, :Gblame...). No leader maps —
  -- use <leader>gg for lazygit and <leader>gv for diffview.
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "Gblame", "Gedit", "Glog" },
  },

  -- fzf-lua: restore C-u = "clear the query box". LazyVim's fzf extra rebinds
  -- C-u to half-page-up (scroll results), which clobbers fzf's default
  -- unix-line-discard. This opts() runs after the extra's, so it wins.
  -- clear-query wipes the whole prompt regardless of cursor position.
  {
    "ibhagwan/fzf-lua",
    opts = function()
      require("fzf-lua").config.defaults.keymap.fzf["ctrl-u"] = "clear-query"
    end,
  },
}
