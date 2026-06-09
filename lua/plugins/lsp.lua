return {
  -- Calmer diagnostics: no distracting inline (virtual) text. Errors are still
  -- marked by a subtle underline + gutter sign. See the full message on demand
  -- with <leader>cd (line diagnostics float), K, or the Trouble list <leader>xx.
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        -- small dot in the gutter instead of E/W/I/H letters; color (red/
        -- yellow/blue/teal) carries the severity. Swap "•" for "●" (bigger)
        -- or "·" (smaller) to taste.
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "•",
            [vim.diagnostic.severity.WARN] = "•",
            [vim.diagnostic.severity.INFO] = "•",
            [vim.diagnostic.severity.HINT] = "•",
          },
        },
      },
    },
  },
}
