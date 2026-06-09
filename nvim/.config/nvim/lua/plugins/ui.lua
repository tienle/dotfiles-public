return {
  -- Neo-tree tuned for a calm, minimal, zen feel: no file icons (folders show
  -- a plain arrow), no git symbol noise, narrower pane, show dotfiles.
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = { width = 32 },
      default_component_configs = {
        icon = {
          folder_closed = "▸",
          folder_open = "▾",
          folder_empty = "▸",
          folder_empty_open = "▾",
          default = "",
          highlight = "NeoTreeFileIcon",
          -- drop per-filetype devicons from files; folders keep the arrows above
          provider = function(icon, node)
            if node.type ~= "directory" then
              icon.text = ""
            end
          end,
        },
        git_status = {
          symbols = {
            added = "",
            modified = "",
            deleted = "",
            renamed = "",
            untracked = "",
            ignored = "",
            unstaged = "",
            staged = "",
            conflict = "",
          },
        },
        modified = { symbol = "" },
      },
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = true,
        },
        follow_current_file = { enabled = true },
      },
    },
  },
}
