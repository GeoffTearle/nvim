return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  -- Everything in opts will be passed to setup()

  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      go = { "goimports", "gci", "golines" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettierd", "prettier", stop_after_first = true },
      lua = { "stylua" },
      proto = { "buf" },
      python = { "ruff_organise_imports", "ruff_fix", "ruff_format" },
      toml = { "taplo" },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      sql = { "sqlfluff" },
    },
    -- Set up format-on-save
    format_on_save = { timeout_ms = 50000 },
    -- Customize formatters
    formatters = {
      golines = {
        prepend_args = { "--max-len=90", "--base-formatter=gofumpt" },
      },
      gci = function()
        return {
          -- A function that calculates the directory to run the command in
          cwd = require("conform.util").root_file({ "go.mod", "go.sum" }),
          -- When cwd is not found, don't run the formatter (default false)
          require_cwd = false,
          append_args = {
            "-s",
            "standard",
            "-s",
            "default",
            "-s",
            "localmodule",
          },
        }
      end,
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
