local SymbolKind = vim.lsp.protocol.SymbolKind

local on_attach = function(client, bufnr)
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

  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  if client.name == "sqls" then
    require("sqls").on_attach(client, bufnr)
  end
end

---@param client vim.lsp.Client
local on_init = function(client, _)
  client.server_capabilities.documentFormattingProvider = nil

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

  if client.name == "sqls" then
    client.server_capabilities.documentFormattingProvider = nil
  end

  if client.name == "golangci_lint_ls" then
    client.server_capabilities.documentFormattingProvider = nil
    client.server_capabilities.signatureHelpProvider = nil
    client.server_capabilities.declarationProvider = nil
    client.server_capabilities.definitionProvider = nil
    client.server_capabilities.implementationProvider = nil
    client.server_capabilities.referencesProvider = nil
    client.server_capabilities.codeLensProvider = nil
    client.server_capabilities.documentLinkProvider = nil
  end

  if client.name == "tailwindcss" then
    --   {
    --   codeActionProvider = true,
    --   colorProvider = true,
    --   completionProvider = {
    --     resolveProvider = true,
    --     triggerCharacters = { '"', "'", "`", " ", ".", "(", "[", "]", "!", "/", "-", ":" }
    --   },
    --   documentLinkProvider = vim.empty_dict(),
    --   hoverProvider = true,
    --   textDocumentSync = {
    --     change = 1,
    --     openClose = true,
    --     save = {
    --       includeText = false
    --     },
    --     willSave = false,
    --     willSaveWaitUntil = false
    --   }
    -- }
    client.server_capabilities.signatureHelpProvider = nil
    client.server_capabilities.declarationProvider = nil
    client.server_capabilities.definitionProvider = nil
    client.server_capabilities.implementationProvider = nil
    client.server_capabilities.diagnosticProvider = nil
    client.server_capabilities.referencesProvider = nil
    client.server_capabilities.codeLensProvider = nil
    client.server_capabilities.documentLinkProvider = nil
  end
end

return {
  "neovim/nvim-lspconfig",
  event = { "BufWritePre", "BufReadPre" },
  dependencies = {
    "nanotee/sqls.nvim",
    {
      "Wansmer/symbol-usage.nvim",
      event = "LspAttach",
      version = "*",
      ---@type UserOpts
      opts = {
        kinds = {
          SymbolKind.Function,
          SymbolKind.Method,
          SymbolKind.Constant,
          SymbolKind.Interface,
          SymbolKind.Enum,
          SymbolKind.Class,
          SymbolKind.Struct,
        },
        references = { enabled = true },
        definition = { enabled = true },
        implementation = { enabled = true },
        disable = {
          lsp = {
            "golangci_lint_ls",
            "ruff",
            "eslint",
            "efm",
            "sqls",
            "tailwindcss",
          },
        },
        filetypes = {},
        log = { enabled = false },
      },
    },
    {
      "creativenull/efmls-configs-nvim",
      version = "v1.x.x", -- version is optional, but recommended
    },
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
    {
      "rachartier/tiny-inline-diagnostic.nvim",
      event = { "BufWritePre", "BufReadPre" },
      -- event = "VeryLazy",
      priority = 1000, -- needs to be loaded in first
      opts = {
        options = {
          show_source = true,
          use_icons_from_diagnostic = true,
          add_messages = true,
          multiple_diag_under_cursor = true,
          multilines = {
            enabled = true,
            always_show = true,
          },
          show_all_diags_on_cursorline = true,
          -- throttle = 0,
          -- enable_on_insert = true,
          throttle = 20,
          enable_on_insert = false,
          -- overwrite_events = { "DiagnosticChanged" }, -- to support files where we have a linter but no lsp
        },
      },
    },
  },
  config = function()
    require("neodev").setup()
    local efmLanguages = {
      json = {
        require("efmls-configs.linters.jq"),
        require("efmls-configs.formatters.jq"),
      },
      gitcommit = {
        require("efmls-configs.linters.gitlint"),
      },
      docker = {
        require("efmls-configs.linters.hadolint"),
      },
    }

    local servers = {
      protols = {},
      buf_ls = {},
      eslint = {},
      sqls = {
        cmd = { "sqls", "-config", "~/.config/sqls/config.yaml" },
      },
      lua_ls = {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            hint = { enable = true, arrayIndex = "Disable" },
            codeLens = {
              enable = true,
            },
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
            "--allow-parallel-runners",
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
            analyses = {
              ST1003 = true,
              fillreturns = true,
              nilness = true,
              nonewvars = true,
              shadow = true,
              undeclaredname = true,
              unreachable = true,
              unusedparams = true,
              unusedvariable = true,
              unusedwrite = true,
              useany = true,
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
            completeUnimported = true,
            diagnosticsDelay = "500ms",
            directoryFilters = { "-.git", "-node_modules" },
            experimentalPostfixCompletions = true,
            gofumpt = true,
            matcher = "Fuzzy",
            semanticTokens = true,
            staticcheck = true,
            symbolMatcher = "fuzzy",
            symbolScope = "all",
            usePlaceholders = true,
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
