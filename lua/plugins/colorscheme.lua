return {
  -- GitHub theme. setup() registers the github_* colorschemes; the actual
  -- `:colorscheme` is applied exactly ONCE by LazyVim via opts.colorscheme
  -- below — no more two-files-fighting double-set.
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,
    priority = 1000,
    opts = {
      options = {
        styles = {
          comments = "italic",
          keywords = "bold",
          functions = "NONE",
          variables = "NONE",
        },
        darken = {
          floats = true,
          sidebars = { enable = true, list = { "qf", "terminal" } },
        },
      },
    },
    config = function(_, opts)
      require("github-theme").setup(opts)
    end,
  },

  -- Single source of truth for the active scheme.
  { "LazyVim/LazyVim", opts = { colorscheme = "github_dark_tritanopia" } },
}
