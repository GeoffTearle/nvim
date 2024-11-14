return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "fredrikaverpil/neotest-golang",
    "nvim-neotest/neotest-python",
  },
  config = function()
    -- get neotest namespace (api call creates or returns namespace)
    local neotest_ns = vim.api.nvim_create_namespace("neotest")
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          return message
        end,
      },
    }, neotest_ns)
    require("neotest").setup({
      -- your neotest config here
      adapters = {
        require("neotest-golang")({
          go_test_args = {
            "-count=1",
            "-tags=integration,unit",
          },
          go_list_args = {
            "-tags=integration,unit",
          },
          dap_go_opts = {
            delve = {
              build_flags = { "-tags=integration,unit" },
            },
          },
        }),
        require("neotest-python")({
          runner = "pytest",
          dap = { justMyCode = true },
          pytest_discover_instances = true,
          args = { "--log-level", "DEBUG" },
          python = function()
            -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
            -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
            -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
            return os.getenv("VIRTUAL_ENV") .. "/bin/python" or "/usr/bin/env python"
          end,
        }),
      },
      discovery = {
        -- Drastically improve performance in ginormous projects by
        -- only AST-parsing the currently opened buffer.
        enabled = false,
        -- Number of workers to parse files concurrently.
        -- A value of 0 automatically assigns number based on CPU.
        -- Set to 1 if experiencing lag.
        concurrent = 0,
      },
      running = {
        -- Run tests concurrently when an adapter provides multiple commands to run.
        concurrent = false,
      },
      summary = {
        -- Enable/disable animation of icons.
        animated = false,
      },
    })
  end,
  keys = require("config.keymap").neotest(),
}
