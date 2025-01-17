local completion_plugin = "magazine.nvim"

if completion_plugin == "magazine.nvim" then
  return {
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp", -- Otherwise highlighting gets messed up
    version = false,
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", version = false, opts = {} },
      { "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua", version = false },
      { "iguanacucumber/mag-buffer", name = "cmp-buffer", version = false },
      { "iguanacucumber/mag-cmdline", name = "cmp-cmdline", commit = "bc85ff5323f4d314f92556bea15ebaac94d58054" },

      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      {
        "MattiasMTS/cmp-dbee",
        dependencies = {
          { "kndndrj/nvim-dbee" },
        },
        ft = "sql", -- optional but good to have
        opts = {}, -- needed
      },
      -- Adds a number of user-friendly snippets
      "rafamadriz/friendly-snippets",
      {
        "windwp/nvim-autopairs",
        -- Optional dependency
        dependencies = { "hrsh7th/nvim-cmp" },
        config = function()
          require("nvim-autopairs").setup({})
          -- If you want to automatically add `(` after selecting a function or method
          local cmp_autopairs = require("nvim-autopairs.completion.cmp")
          local cmp = require("cmp")
          cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },
    },
    config = function(_, opts)
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local compare = require("cmp.config.compare")

      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),

          ["<A-j>"] = cmp.mapping.select_next_item(),
          ["<A-k>"] = cmp.mapping.select_prev_item(),

          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          ["<C-Space>"] = cmp.mapping.complete({}),
          ["<Nul>"] = cmp.mapping.complete({}),

          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
            if cmp.visible() then
              local entry = cmp.get_selected_entry()
              if not entry then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Replace })
                cmp.confirm()
              else
                cmp.confirm()
              end
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s", "c" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp", group_index = 1, keyword_length = 1 },
          { name = "nvim_lsp_signature_help" },
          { name = "luasnip", group_index = 1, priority = -1, keyword_length = 1 },
          { name = "nvim_lua", group_index = 1, keyword_length = 1 },
          { name = "cmp-dbee", group_index = 1, keyword_length = 1 },
          { name = "buffer", group_index = 1, keyword_length = 1 },
          -- { name = "path", max_item_count = 5 },
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            compare.offset,
            compare.exact,
            compare.scopes,
            compare.score,
            compare.recently_used,
            compare.locality,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
          },
        },
      })

      require("cmp").setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "nvim_lsp_document_symbol" },
        }, {
          { name = "buffer" },
        }),
      })

      require("cmp").setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            -- option = {
            --   ignore_cmds = { "Man", "!" },
            -- },
          },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
      })
    end,
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
