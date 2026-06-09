return {
  -- Rails navigation/helpers (:Rails, gf to partials, :Emodel, etc.).
  -- The ruby LSP/format/treesitter all come from the lang.ruby extra.
  { "tpope/vim-rails", ft = { "ruby", "eruby", "haml", "slim" } },

  -- Test adapters. The neotest framework + keymaps come from the test.core
  -- extra; rust (rustaceanvim) and go (lang.go) wire up their own adapters.
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "olimorris/neotest-rspec",
      "nvim-neotest/neotest-jest",
    },
    opts = {
      adapters = {
        ["neotest-rspec"] = {
          -- ported: runs specs inside Docker via `dip`. Change to
          -- { "bundle", "exec", "rspec" } for a plain local setup.
          rspec_cmd = function()
            return { "dip", "rspec" }
          end,
        },
        ["neotest-jest"] = {},
      },
    },
  },

  -- Markdown browser preview. The markdown extra already ships the plugin and
  -- the <leader>cp toggle; this just sets nicer defaults.
  {
    "iamcco/markdown-preview.nvim",
    init = function()
      vim.g.mkdp_auto_close = 0 -- keep the browser tab open when you switch buffers
      vim.g.mkdp_theme = "dark" -- match the dark colorscheme
    end,
  },
}
