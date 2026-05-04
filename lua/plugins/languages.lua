return {
  -- Ruby/Rails
  {
    "tpope/vim-rails",
    ft = { "ruby" },
  },

  {
    "keith/rspec.vim",
    ft = { "ruby" },
  },
  -- Faster Ruby syntax highlighting
  {
    "RRethy/nvim-treesitter-endwise",
    ft = { "ruby", "eruby" },
    config = function()
      require("nvim-treesitter.configs").setup({
        endwise = { enable = true },
      })
    end,
  },

  -- JavaScript/TypeScript
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    opts = {},
  },

  -- JSON
  {
    "b0o/schemastore.nvim",
    ft = { "json", "jsonc" },
  },

  -- ReasonML/ReScript
  {
    "reasonml-editor/vim-reason-plus",
    ft = { "reason" },
  },

  {
    "rescript-lang/vim-rescript",
    ft = { "rescript" },
  },

  -- Elixir
  {
    "elixir-editors/vim-elixir",
    ft = { "elixir" },
  },

  -- HTML
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "xml" },
    config = true,
  },

  -- Mix formatting for Elixir
  {
    "mhinz/vim-mix-format",
    ft = { "elixir" },
    init = function()
      vim.g.mix_format_on_save = 1
    end,
  },
}
