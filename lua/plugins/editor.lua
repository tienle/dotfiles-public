return {
  -- FZF-lua with max-perf profile
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup({
        "default", -- Use the max-perf profile for best performance
        -- You can override specific settings if needed
        winopts = {
          fullscreen = true, -- Keep your fullscreen preference
        },
      })
    end,
    keys = {
      { "<Leader>fs",      "<cmd>FzfLua live_grep<cr>",    desc = "Live grep" },
      { "<Leader><Space>", "<cmd>FzfLua files<cr>",        desc = "Find files" },
      { "<Leader>ff",      "<cmd>FzfLua files<cr>",        desc = "Find files" },
      { "<Leader>fh",      "<cmd>FzfLua oldfiles<cr>",     desc = "Recent files" },
      { "<Leader>fb",      "<cmd>FzfLua buffers<cr>",      desc = "Buffers" },
      { "<Leader>fc",      "<cmd>FzfLua git_commits<cr>",  desc = "Git commits" },
      { "<Leader>fC",      "<cmd>FzfLua git_bcommits<cr>", desc = "Buffer commits" },
      { "<Leader>ft",      "<cmd>FzfLua btags<cr>",        desc = "Buffer tags" },
      { "<Leader>F",       "<cmd>FzfLua grep_cword<cr>",   desc = "Grep word under cursor" },
    },
  },

  -- Search and replace
  {
    "nvim-pack/nvim-spectre",
    keys = {
      { "<leader>sr", "<cmd>lua require('spectre').open()<cr>",                          desc = "Replace in files (Spectre)" },
      { "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", desc = "Search current word" },
    },
  },

  -- Enhanced search
  {
    "kevinhwang91/nvim-hlslens",
    keys = {
      { "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { "*", [[*<Cmd>lua require('hlslens').start()<CR>]] },
      { "#", [[#<Cmd>lua require('hlslens').start()<CR>]] },
    },
    config = true,
  },

  -- Motion plugins
  {
    "ggandor/leap.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
    },
    config = function()
      require("leap").add_default_mappings()
    end,
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = true,
  },

  -- Comments
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {
      toggler = {
        line = "gcc",
        block = "gbc",
      },
      opleader = {
        line = "gc",
        block = "gb",
      },
    },
  },

  -- Better text objects
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
  },

  -- Multiple cursors alternative
  {
    "mg979/vim-visual-multi",
    keys = {
      { "<C-n>", mode = { "n", "v" } },
      { "<C-p>", mode = { "n", "v" } },
      { "<C-x>", mode = { "n", "v" } },
      { ",mc",   mode = { "n", "v" } },
    },
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
        ["Find Next"] = "n",
        ["Find Prev"] = "N",
        ["Skip Region"] = "<C-x>",
        ["Remove Region"] = "Q",
        ["Start Regex Search"] = ",mc",
      }
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
      },
    },
  },

  -- Align text
  {
    "echasnovski/mini.align",
    keys = {
      { "ga", mode = { "n", "v" } },
    },
    opts = {},
  },

  -- Targets.vim
  {
    "wellle/targets.vim",
    event = "VeryLazy",
  },

  -- Repeat
  {
    "tpope/vim-repeat",
    event = "VeryLazy",
  },

  -- Unimpaired
  {
    "tpope/vim-unimpaired",
    event = "VeryLazy",
  },

  -- Yank history
  {
    "gbprod/yanky.nvim",
    keys = {
      { "p",     "<Plug>(YankyPutAfter)",     mode = { "n", "x" } },
      { "P",     "<Plug>(YankyPutBefore)",    mode = { "n", "x" } },
      { "<c-n>", "<Plug>(YankyCycleForward)" },
      { "<c-p>", "<Plug>(YankyCycleBackward)" },
    },
    opts = {
      highlight = {
        timer = 150,
      },
    },
  },
}
