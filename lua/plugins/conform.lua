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
      nix = { "alejandra" },
      proto = { "buf" },
      python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
      toml = { "taplo" },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      sql = { "sqlfluff_format", "sqlfluff_fix" },
    },
    -- Set up format-on-save
    format_on_save = { timeout_ms = 5000 },
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
      sqlfluff_format = function()
        return {
          command = "sqlfluff",
          args = { "format", "-" },
          stdin = true,
          cwd = require("conform.util").root_file({
            ".sqlfluff",
            "pep8.ini",
            "pyproject.toml",
            "setup.cfg",
            "tox.ini",
          }),
          require_cwd = true,
        }
      end,
      sqlfluff_fix = function()
        return {
          command = "sqlfluff",
          args = { "fix", "-" },
          exit_codes = { 0, 1 }, -- ignore exit code 1 as this happens when there simply exist unfixable lints
          stdin = true,
          cwd = require("conform.util").root_file({
            ".sqlfluff",
            "pep8.ini",
            "pyproject.toml",
            "setup.cfg",
            "tox.ini",
          }),
          require_cwd = true,
        }
      end,
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
