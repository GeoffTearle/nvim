-- lspconfig.lua
-- NOTE: This is where your plugins related to LSP can be installed.
--   callback = function(ev)
--     local client = vim.lsp.get_client_by_id(ev.data.client_id)
--     if client == nil then
--       return
--     end
--
--     if client.name == "gopls" then
--       if not client.server_capabilities.semanticTokensProvider then
--         local semantic = client.config.capabilities.textDocument.semanticTokens
--         if semantic == nil then
--           return
--         end
--
--         client.server_capabilities.semanticTokensProvider = {
--           full = true,
--           legend = {
--             tokenTypes = semantic.tokenTypes,
--             tokenModifiers = semantic.tokenModifiers,
--           },
--           range = true,
--         }
--       end
--     end
--   end,
-- })
-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.

  local map = function(mode, keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
  end

  local nmap = function(keys, func, desc)
    map("n", keys, func, desc)
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
  -- nmap("<M-CR>", vim.lsp.buf.code_action, "Code Action")
  map({ "n", "v" }, "<M-CR>", "<cmd>Lspsaga code_action<CR>", "Code Action")
  map({ "i" }, "<M-CR>", "<esc><cmd>Lspsaga code_action<CR>", "Code Action")

  -- nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
  -- nmap("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  -- nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
  -- nmap("gt", vim.lsp.buf.type_definition, "[G]oto [T]ype Definition")
  nmap("gt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
  nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<leader>k", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })

  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

local on_init = function(client, _)
  if client.name == "gopls" then
    if not client.server_capabilities.semanticTokensProvider then
      local semantic = client.config.capabilities.textDocument.semanticTokens
      if semantic ~= nil then
        client.server_capabilities.semanticTokensProvider = {
          full = true,
          legend = {
            tokenTypes = semantic.tokenTypes,
            tokenModifiers = semantic.tokenModifiers,
          },
          range = true,
        }
      end
    end
  end
end

return {
  -- LSP Configuration & Plugins
  "neovim/nvim-lspconfig",
  -- lazy = false,
  event = { "BufWritePre", "BufReadPre" },
  dependencies = {
    -- Useful status updates for LSP
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    -- { "j-hui/fidget.nvim", opts = {} },
    {
      "Wansmer/symbol-usage.nvim",
      event = "LspAttach",
      version = "*",
      config = function()
        local SymbolKind = vim.lsp.protocol.SymbolKind
        ---@type UserOpts
        require("symbol-usage").setup({
          ---@type table<string, any> `nvim_set_hl`-like options for highlight virtual text
          hl = { link = "Comment" },
          ---@type lsp.SymbolKind[] Symbol kinds what need to be count (see `lsp.SymbolKind`)
          kinds = { SymbolKind.Function, SymbolKind.Method },
          ---Additional filter for kinds. Recommended use in the filetypes override table.
          ---fiterKind: function(data: { symbol:table, parent:table, bufnr:integer }): boolean
          ---`symbol` and `parent` is an item from `textDocument/documentSymbol` request
          ---See: #filter-kinds
          ---@type table<lsp.SymbolKind, filterKind[]>
          kinds_filter = {},
          ---@type 'above'|'end_of_line'|'textwidth'|'signcolumn' `above` by default
          vt_position = "above",
          vt_priority = nil, ---@type integer Virtual text priority (see `nvim_buf_set_extmark`)
          ---Text to display when request is pending. If `false`, extmark will not be
          ---created until the request is finished. Recommended to use with `above`
          ---vt_position to avoid "jumping lines".
          ---@type string|table|false
          request_pending_text = "loading...",
          ---The function can return a string to which the highlighting group from `opts.hl` is applied.
          ---Alternatively, it can return a table of tuples of the form `{ { text, hl_group }, ... }`` - in this case the specified groups will be applied.
          ---If `vt_position` is 'signcolumn', then only a 1-2 length string or a `{{ icon, hl_group }}` table is expected.
          ---See `#format-text-examples`
          ---@type function(symbol: Symbol): string|table Symbol{ definition = integer|nil, implementation = integer|nil, references = integer|nil, stacked_count = integer, stacked_symbols = table<SymbolId, Symbol> }
          -- text_format = function(symbol) end,
          references = { enabled = true, include_declaration = false },
          definition = { enabled = true },
          implementation = { enabled = true },
          ---@type { lsp?: string[], filetypes?: string[], cond?: function[] } Disables `symbol-usage.nvim' for specific LSPs, filetypes, or on custom conditions.
          ---The function in the `cond` list takes an argument `bufnr` and returns a boolean. If it returns true, `symbol-usage` will not run in that buffer.
          disable = { lsp = {}, filetypes = {}, cond = {} },
          ---@type UserOpts[] See default overridings in `lua/symbol-usage/langs.lua`
          -- filetypes = {},
          ---@type 'start'|'end' At which position of `symbol.selectionRange` the request to the lsp server should start. Default is `end` (try changing it to `start` if the symbol counting is not correct).
          symbol_request_pos = "end", -- Recommended redefine only in `filetypes` override table
          ---@type LoggerConfig
          log = { enabled = false },
        })
      end,
    },
    -- {
    --   "VidocqH/lsp-lens.nvim",
    --   event = "LspAttach",
    --   version = "*",
    --   opts = {
    --     sections = { -- Enable / Disable specific request, formatter example looks 'Format Requests'
    --       definition = true,
    --       references = true,
    --       implements = true,
    --       git_authors = false,
    --     },
    --   },
    -- },
    {
      "creativenull/efmls-configs-nvim",
      version = "v1.x.x", -- version is optional, but recommended
    },
    -- Additional lua configuration, makes nvim stuff amazing!
    "folke/neodev.nvim",
    {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {
        on_attach = on_attach,
        settings = {
          tsserver_file_preferences = {
            includeCompletionsForModuleExports = true,
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
    },
    -- {
    --   "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    --   config = function()
    --     require("lsp_lines").setup()
    --     vim.diagnostic.config({ virtual_text = false, underline = true, float = false })
    --   end,
    -- },
    -- {
    --   "sontungexpt/better-diagnostic-virtual-text",
    --   event = "LspAttach",
    --   priority = 1000, -- needs to be loaded in first
    --   config = function()
    --     require("better-diagnostic-virtual-text").setup({
    --       inline = false,
    --     })
    --     vim.diagnostic.config({ virtual_text = false, underline = true, float = false })
    --   end,
    -- },
    {
      "luckasRanarison/tailwind-tools.nvim",
      name = "tailwind-tools",
      build = ":UpdateRemotePlugins",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope.nvim", -- optional
      },
      opts = {}, -- your configuration
    },
    -- {
    --   "artemave/workspace-diagnostics.nvim",
    -- },
    {
      "rachartier/tiny-inline-diagnostic.nvim",
      event = "LspAttach",
      priority = 1000, -- needs to be loaded in first
      opts = {
        options = {
          -- Show the source of the diagnostic.
          show_source = true,
          -- Use your defined signs in the diagnostic config table.
          use_icons_from_diagnostic = true,
          -- Add messages to the diagnostic when multilines is enabled
          add_messages = true,
          -- Throttle the update of the diagnostic when moving cursor, in milliseconds.
          -- You can increase it if you have performance issues.
          -- Or set it to 0 to have better visuals.
          throttle = 0,
          -- The minimum length of the message, otherwise it will be on a new line.
          softwrap = 30,
          -- If multiple diagnostics are under the cursor, display all of them.
          multiple_diag_under_cursor = true,
          -- Enable diagnostic message on all lines.
          multilines = true,
          -- Show all diagnostics on the cursor line.
          show_all_diags_on_cursorline = true,
          -- Enable diagnostics on Insert mode. You should also se the `throttle` option to 0, as some artefacts may appear.
          enable_on_insert = true,
          overflow = {
            -- Manage the overflow of the message.
            --    - wrap: when the message is too long, it is then displayed on multiple lines.
            --    - none: the message will not be truncated.
            --    - oneline: message will be displayed entirely on one line.
            mode = "wrap",
          },
          -- Format the diagnostic message.
          -- Example:
          -- format = function(diagnostic)
          --     return diagnostic.message .. " [" .. diagnostic.source .. "]"
          -- end,
          format = nil,
          --- Enable it if you want to always have message with `after` characters length.
          break_line = {
            enabled = false,
            after = 30,
          },
          virt_texts = {
            priority = 2048,
          },
          -- Filter by severity.
          severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.INFO,
            vim.diagnostic.severity.HINT,
          },
          -- Overwrite events to attach to a buffer. You should not change it, but if the plugin
          -- does not works in your configuration, you may try to tweak it.
          overwrite_events = nil,
        },
      },
      config = function(_, opts)
        require("tiny-inline-diagnostic").setup(opts)
      end,
      _ = {},
    },
  },
  config = function()
    require("neodev").setup()
    local efmLanguages = {
      -- typescript = {
      --   require("efmls-configs.linters.eslint_d"),
      --   -- require("efmls-configs.formatters.prettier_d"),
      -- },
      -- typescriptreact = {
      --   require("efmls-configs.linters.eslint_d"),
      --   -- require("efmls-configs.formatters.prettier_d"),
      -- },
      proto = {
        require("efmls-configs.linters.buf"),
        -- require("efmls-configs.formatters.buf"),
      },
      json = {
        require("efmls-configs.linters.jq"),
        -- require("efmls-configs.formatters.prettier_d"),
      },
      gitcommit = {
        require("efmls-configs.linters.gitlint"),
      },
      docker = {
        require("efmls-configs.linters.hadolint"),
      },
      -- sql = {
      --   require("efmls-configs.linters.sqlfluff"),
      -- },
    }

    local servers = {
      protols = {},
      buf_ls = {},
      eslint = {},
      lua_ls = {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            hint = { enable = true },
          },
        },
      },
      nixd = {
        cmd = { "nixd", "--semantic-tokens=true", "--inlay-hints=true" },
        settings = {
          nixd = {
            nixpkgs = {
              expr = "import <nixpkgs> { }",
            },
            options = {
              nixos = {
                expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.k-on.options',
              },
              home_manager = {
                expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."ruixi@k-on".options',
              },
            },
          },
        },
      },
      golangci_lint_ls = {
        init_options = {
          command = {
            "golangci-lint",
            "run",
            "--tests",
            "--build-tags",
            "integration,unit",
            "--concurrency",
            "16",
            "--max-issues-per-linter",
            "0",
            "--max-same-issues",
            "0",
            "--out-format",
            "json",
          },
        },
      },
      gopls = {
        flags = { debounce_text_changes = 200 },
        single_file_support = false,
        settings = {
          gopls = {
            usePlaceholders = true,
            gofumpt = true,
            analyses = {
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              unusedvariable = true,
              useany = true,
              shadow = true,
            },
            codelenses = {
              gc_details = true,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            experimentalPostfixCompletions = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-node_modules" },
            semanticTokens = true,
            symbolScope = "all",
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            buildFlags = { "-tags=integration,unit" },
          },
        },
        init_options = {
          usePlaceholders = true,
        },
      },
      efm = {
        filetypes = vim.tbl_keys(efmLanguages),
        settings = {
          rootMarkers = { ".git/" },
          languages = efmLanguages,
        },
        init_options = {
          documentFormatting = true,
          documentRangeFormatting = true,
        },
      },
      yamlls = {
        settings = {
          yaml = {
            schemas = {
              ["https://raw.githubusercontent.com/quantumblacklabs/kedro/develop/static/jsonschema/kedro-catalog-0.17.json"] = "conf/**/*catalog*",
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            },
          },
          redhat = {
            telemetry = {
              enabled = false,
            },
          },
        },
      },
      ruff = {
        init_options = {
          settings = {
            lineLength = 90,
            configurationPreference = "editorFirst",
            fixAll = false,
            organizeImports = false,
            showSyntaxErrors = true,
            codeAction = {
              fixViolation = {
                enable = true,
              },
              disableRuleComment = {
                enable = true,
              },
            },
            lint = {
              enable = true,
              extendSelect = {
                "A",
                "ARG",
                "ASYNC",
                "BLE",
                "C4",
                "COM",
                "E4",
                "E7",
                "E9",
                "ERA",
                "F",
                "FBT",
                "FIX",
                "FURB",
                "I",
                "ICN",
                "INT",
                "ISC",
                "N",
                "PIE",
                "PL",
                "PTH",
                "RET",
                "RUF",
                "SIM",
                "SLF",
                "SLOT",
                "TCH",
                "TD",
                "TID",
                "YTT",
              },
              extendIgnore = {
                "PLR0904",
                "PLR0911",
                "ANN003",
              },
              ignore = {
                "PLR0904",
                "PLR0911",
                "ANN003",
              },
            },
          },
        },
      },
      basedpyright = {
        settings = {
          basedpyright = {
            disableOrganizeImports = true,
            analysis = {
              autoSearchPaths = true,
              autoImportCompletions = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
            },
          },
        },
      },
    }

    local client_capabilities = function()
      return vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        -- nvim-cmp supports additional completion capabilities, so broadcast that to servers.
        -- require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
        require("cmp_nvim_lsp").default_capabilities(),
        -- vim.lsp.protocol.make_client_capabilities(),
        {
          workspace = {
            didChangeWatchedFiles = { dynamicRegistration = true },
          },
        }
      )
    end

    local capabilities = client_capabilities()

    for _, server_name in pairs(vim.tbl_keys(servers)) do
      require("lspconfig")[server_name].setup(vim.tbl_extend("force", servers[server_name] or {}, {
        capabilities = capabilities,
        on_attach = on_attach,
        on_init = on_init,
      }))
    end
  end,
  _ = {},
}
