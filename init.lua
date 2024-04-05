local optsMgr = require("config.options")
optsMgr.apply()

local pluginMgr = require("config.plugins")
pluginMgr.ensureInstalled()
pluginMgr.load()

local keybindMgr = require("config.keymap")
keybindMgr.general()

-- Move to setup
keybindMgr.telescope()

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("local_config_" .. "pdf", { clear = true }),
  pattern = "*.pdf",
  command = "execute \"! zathura '%' &\" | bdelete %",
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
  },
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
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

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
end

local efmLanguages = {
  typescript = {
    require("efmls-configs.linters.eslint_d"),
    require("efmls-configs.formatters.prettier_d"),
  },
  typescriptreact = {
    require("efmls-configs.linters.eslint_d"),
    require("efmls-configs.formatters.prettier_d"),
  },
  lua = {
    require("efmls-configs.linters.luacheck"),
    require("efmls-configs.formatters.stylua"),
  },
  proto = {
    require("efmls-configs.linters.buf"),
    -- require("efmls-configs.formatters.buf"),
  },
  json = {
    require("efmls-configs.linters.jq"),
    require("efmls-configs.formatters.prettier_d"),
  },
}

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  golangci_lint_ls = {},
  tsserver = {},
  bufls = {},
  gopls = {
    keys = {
      -- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
      { "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
    },
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
      },
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
}

local is_pinephone = function()
  local os = vim.trim(vim.fn.system("uname -s"))
  local arch = vim.trim(vim.fn.system("uname -m"))
  if os == "Linux" and arch == "aarch64" then
    return true
  end
  return false
end

if not is_pinephone() then
  servers.lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  }
end

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
  function(server_name)
    if is_pinephone() then
      if server_name == "lua_ls" then
        return
      end
    end

    require("lspconfig")[server_name].setup(vim.tbl_extend("force", servers[server_name] or {}, {
      capabilities = capabilities,
      on_attach = on_attach,
    }))
  end,
})

if is_pinephone() then
  local lspconfig = require("lspconfig")

  lspconfig.lua_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  })
end

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require("cmp")
local luasnip = require("luasnip")

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
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          cmp.confirm()
        else
          cmp.confirm()
        end
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
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer",                 keyword_length = 5 },
    { name = "path" },
    { name = "nvim_lsp_signature_help" },
  },
})

require("cmp").setup.cmdline("/", {
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
      option = {
        ignore_cmds = { "Man", "!" },
      },
    },
  }),
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
