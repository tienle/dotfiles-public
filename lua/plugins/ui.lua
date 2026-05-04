return {
  -- File explorer (modern replacement for NERDTree)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { ",nt",       "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
      { "<leader>e", "<cmd>NvimTreeFocus<CR>",  desc = "Focus file tree" },
    },
    config = function()
      -- Disable netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        view = {
          width = 50,
          side = "left",
        },
        renderer = {
          add_trailing = false,
          group_empty = false,
          highlight_git = false,
          full_name = false,
          highlight_opened_files = "name",
          icons = {
            show = {
              file = false,
              folder = false,
              folder_arrow = true,
              git = false,
            },
            -- glyphs = {
            --   folder = {
            --     arrow_closed = "▸",
            --     arrow_open = "▾",
            --   },
            -- },
          },
          special_files = {},
        },
        update_focused_file = {
          enable = true,
          update_cwd = false,
        },
        filters = {
          dotfiles = false,
          custom = { ".git", "node_modules", ".cache" },
        },
        git = {
          enable = false,
        },
      })
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto", -- Automatically matches your colorscheme
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "diagnostics" },            -- Removed branch and diff
          lualine_c = { { "filename", path = 1 } }, -- Full relative path
          lualine_x = { "filetype" },               -- Simplified right side
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- Comment out indent guides for minimal style
  -- {
  --   "lukas-reineke/indent-blankline.nvim",
  --   main = "ibl",
  --   event = { "BufReadPre", "BufNewFile" },
  --   opts = {
  --     indent = {
  --       char = "│",
  --       tab_char = "│",
  --     },
  --     scope = { enabled = false },
  --     exclude = {
  --       filetypes = {
  --         "help",
  --         "lazy",
  --         "mason",
  --         "notify",
  --         "toggleterm",
  --         "lazyterm",
  --       },
  --     },
  --   },
  -- },

  -- Better UI
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        enabled = true,
        default_prompt = "➤ ",
      },
      select = {
        enabled = true,
        backend = { "telescope", "builtin" },
      },
    },
  },

  -- Zen mode (replacement for goyo)
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
    },
    opts = {
      window = {
        width = 0.85,
      },
    },
  },
}
