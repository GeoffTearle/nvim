return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "fredrikaverpil/neotest-golang",
    -- "nvim-neotest/neotest-go",
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
        require("neotest-golang")({ -- Specify configuration
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
        }), -- Registration
        -- require("neotest-go")({
        --   experimental = {
        --     test_table = true,
        --   },
        --   args = { "-count=1" },
        -- }),
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
