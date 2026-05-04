return {
  -- GitHub Theme (most authentic GitHub look)
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({
        options = {
          -- Choose from: 'github_dark', 'github_dark_default', 'github_dark_dimmed',
          -- 'github_dark_high_contrast', 'github_dark_colorblind', 'github_dark_tritanopia',
          -- 'github_light', 'github_light_default', 'github_light_high_contrast',
          -- 'github_light_colorblind', 'github_light_tritanopia'
          styles = {
            comments = "italic",
            keywords = "bold",
            functions = "NONE",
            variables = "NONE",
          },
          darken = {
            floats = true,
            sidebars = {
              enable = true,
              list = { "qf", "vista_kind", "terminal", "packer" },
            },
          },
        },
      })
      -- Set to GitHub light theme (like GitHub.com)
      vim.cmd("colorscheme github_light")
    end,
  },

  -- GitHub VSCode theme port
  {
    "Mofiqul/vscode.nvim",
    lazy = true,
    config = function()
      require("vscode").setup({
        style = "light", -- "light" or "dark"
        transparent = false,
        italic_comments = true,
      })
    end,
  },

  -- Alternative themes (lazy loaded)
  { "joshdick/onedark.vim",        lazy = true },
  { "sickill/vim-monokai",         lazy = true },
  { "andreypopp/vim-colors-plain", lazy = true },
}
