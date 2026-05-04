return {
  -- LSP Configuration (modern alternative to coc.nvim)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    dependencies = {
      -- LSP installer
      { "williamboman/mason.nvim",           config = true },
      { "williamboman/mason-lspconfig.nvim", version = "v1.31.0" }, -- Last version supporting Neovim 0.10

      -- Useful status updates for LSP
      { "j-hui/fidget.nvim",                 opts = {} },

      -- Additional lua configuration
      "folke/neodev.nvim",
    },
    config = function()
      -- Setup neodev for Neovim config development
      require("neodev").setup()

      -- LSP keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>ac", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>qf", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]g", vim.diagnostic.goto_next, opts)
        end,
      })

      -- Configure diagnostics
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
      })

      -- Setup mason-lspconfig
      require("mason-lspconfig").setup({
        ensure_installed = {
          "tsserver",
          "eslint",
          "html",
          "cssls",
          "jsonls",
          "yamlls",
          "lua_ls",
          "solargraph",
          "vimls",
        },
      })

      -- Setup servers
      local lspconfig = require("lspconfig")
      -- Note: blink.cmp doesn't require capabilities to be passed to LSP servers

      -- Default handler
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({})
        end,

        -- Custom configurations
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            settings = {
              Lua = {
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
              },
            },
          })
        end,

        ["solargraph"] = function()
          lspconfig.solargraph.setup({
            cmd = { "solargraph", "stdio" },
            settings = {
              solargraph = {
                diagnostics = true,
                completion = true,
                -- These settings help with Rails completions
                useBundler = true,
                rails = true, -- Enable Rails support
                definitions = true,
                rename = true,
                references = true,
                symbols = true,
                folding = true,
              },
            },
            init_options = {
              formatting = true,
            },
          })
        end,
      })
    end,
  },

  -- Modern all-in-one completion with blink.cmp
  {
    "saghen/blink.cmp",
    lazy = false, -- Needed for performance
    dependencies = "rafamadriz/friendly-snippets",
    version = "v0.*",
    opts = {
      keymap = {
        preset = 'default',
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<Tab>'] = { 'select_next', 'select_and_accept', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'normal'
      },

      sources = {
        providers = {
          lsp = {
            name = 'LSP',
            module = 'blink.cmp.sources.lsp',
            fallbacks = {},
            score_offset = 0,
          },
        },
        -- Ensure buffer is in the default list
        default = { 'buffer', 'lsp', 'path', 'snippets' },
        min_keyword_length = 2, -- This might be the correct place for minimum length
      },

      fuzzy = {
        sorts = {
          'exact',
          -- defaults
          'score',
          'sort_text',
        },
      },

      -- Cmdline configuration (new API)
      cmdline = {
        enabled = false, -- Disable cmdline completion for minimal setup
      },

      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        ghost_text = {
          enabled = false,
        },
        menu = {
          border = 'single',
          draw = {
            columns = {
              { "label",     "label_description", gap = 1 },
              { "kind_icon", "kind" }
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 120,
        },
      },

      signature = { enabled = true },
    },
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        ruby = { "rubocop" },
        elixir = { "mix" },
      },
      -- Or if you want to keep format on save but with longer timeout:
      format_on_save = {
        timeout_ms = 5000, -- 5 second timeout
        lsp_fallback = true,
      },
      formatters = {
        rubocop = {
          timeout_ms = 5000, -- 5 second timeout for rubocop
          command = "rubocop",
          args = {
            "--auto-correct-all",
            "--stdin",
            "$FILENAME",
            "--format",
            "quiet",
            "--stderr",
          },
        },
      },
    },
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        javascript = { "eslint" },
        typescript = { "eslint" },
        javascriptreact = { "eslint" },
        typescriptreact = { "eslint" },
        ruby = { "rubocop" },
      }

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("lint", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
