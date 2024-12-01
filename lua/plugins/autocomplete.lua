local completion_plugin = "blink.cmp"

if completion_plugin == "magazine.nvim" then
  ---@module 'lazy.nvim'
  ---@type LazyPlugin
  return {
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp", -- Otherwise highlighting gets messed up
    version = false,
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- Adds LSP completion capabilities
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-nvim-lsp-signature-help",

      -- Adds a number of user-friendly snippets
      "rafamadriz/friendly-snippets",
    },
    _ = {},
  }
end

if completion_plugin == "blink.cmp" then
  return {
    "saghen/blink.cmp",
    version = "v0.*",
    lazy = false, -- lazy loading handled internally
    dependencies = {
      { "rafamadriz/friendly-snippets" },
      {
        "saghen/blink.compat",
        version = "v0.*",
        dependencies = {
          {
            "MattiasMTS/cmp-dbee",
            lazy = true,
            dependencies = {
              { "kndndrj/nvim-dbee" },
            },
            ft = "sql",
            opts = {}, -- needed
          },
        },
        opts = {
          -- some plugins lazily register their completion source when nvim-cmp is
          -- loaded, so pretend that we are nvim-cmp, and that nvim-cmp is loaded.
          -- most plugins don't do this, so this option should rarely be needed
          -- NOTE: only has effect when using lazy.nvim plugin manager
          impersonate_nvim_cmp = false,

          -- some sources, like codeium.nvim, rely on nvim-cmp events to function properly
          -- when enabled, emit those events
          -- NOTE: somewhat hacky, may harm performance or break
          enable_events = false,

          -- print some debug information. Might be useful for troubleshooting
          debug = false,
        },
      },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      highlight = {
        use_nvim_cmp_as_default = true,
      },
      nerd_font_variant = "mono",

      keymap = {
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = {
          function(cmp)
            if cmp.is_in_snippet() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },

        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },

      accept = { auto_brackets = { enabled = true } },
      trigger = {
        completion = {
          show_in_snippet = true,
        },

        signature_help = {
          enabled = true,
        },
      },
      windows = {
        autocomplete = {
          -- Controls how the completion items are selected
          -- 'preselect' will automatically select the first item in the completion list
          -- 'manual' will not select any item by default
          -- 'auto_insert' will not select any item by default, and insert the completion items automatically when selecting them
          selection = "preselect",
          -- Controls how the completion items are rendered on the popup window
          -- 'simple' will render the item's kind icon the left alongside the label
          -- 'reversed' will render the label on the left and the kind icon + name on the right
          -- 'minimal' will render the label on the left and the kind name on the right
          -- 'function(blink.cmp.CompletionRenderContext): blink.cmp.Component[]' for custom rendering
          -- draw = "simple",
          winblend = vim.o.pumblend,
        },

        documentation = {
          auto_show = false, -- makes wayyy to many errors show
        },
        ghost_text = {
          enabled = false,
        },
      },
      sources = {
        -- list of enabled providers
        completion = {
          enabled_providers = { "lsp", "dbee", "path", "snippets", "buffer" },
        },

        -- Please see https://github.com/Saghen/blink.compat for using `nvim-cmp` sources
        providers = {
          dbee = {
            name = "cmp-dbee", -- IMPORTANT: use the same name as you would for nvim-cmp
            module = "blink.compat.source",
            fallback_for = { "lsp" },
            score_offset = 1,
            enabled = function(ctx)
              if not ctx then
                return false
              end

              local ft = vim.api.nvim_buf_get_option(ctx.bufnr, "filetype")
              if ft == "sql" then
                return true
              end

              return false
            end,
          },
        },
      },
    },
  }
end
