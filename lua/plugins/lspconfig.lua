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

---@module 'lazy.nvim'
---@type LazyPlugin
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
      "creativenull/efmls-configs-nvim",
      version = "v1.x.x", -- version is optional, but recommended
    },
    -- Additional lua configuration, makes nvim stuff amazing!
    "folke/neodev.nvim",
    {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = { on_attach = on_attach },
    },
    {
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = function()
        require("lsp_lines").setup()
        vim.diagnostic.config({ virtual_text = false, underline = true, float = false })
      end,
    },
    -- {
    --   "rachartier/tiny-inline-diagnostic.nvim",
    --   event = "VeryLazy", -- Or `LspAttach`
    --   priority = 1000, -- needs to be loaded in first
    --   opts = {
    --     options = {
    --       show_source = true,
    --       multilines = true,
    --       break_line = {
    --         enabled = false,
    --         after = 30,
    --       },
    --     },
    --   },
    --   config = function(_, opts)
    --     vim.diagnostic.config({ virtual_text = false, underline = true, float = false })
    --     require("tiny-inline-diagnostic").setup(opts)
    --   end,
    --   _ = {},
    -- },
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
            didChangeWatchedFiles = { dynamicRegistration = false },
          },
        }
      )
    end

    local capabilities = client_capabilities()

    for _, server_name in pairs(vim.tbl_keys(servers)) do
      require("lspconfig")[server_name].setup(vim.tbl_extend("force", servers[server_name] or {}, {
        capabilities = capabilities,
        on_attach = on_attach,
      }))
    end
  end,
  _ = {},
}
