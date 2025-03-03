return {
  -- {
  --   "rachartier/tiny-glimmer.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     -- your configuration
  --   },
  -- },
  {
    "lukas-reineke/indent-blankline.nvim",
    dependencies = {
      "TheGLander/indent-rainbowline.nvim",
    },
    main = "ibl",
    config = function()
      local opts = require("indent-rainbowline").make_opts()
      require("ibl").setup(opts)
    end,
  },
  -- save my last cursor position
  {
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
        lastplace_open_folds = true,
      })
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    ---@type NoiceConfig
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
        documentation = {
          view = "hover",
          ---@type NoiceViewOptions
          opts = {
            -- lang = "markdown",
            -- replace = true,
            -- render = "plain",
            -- format = { "{message}" },
            win_options = { concealcursor = "nvic", conceallevel = 0, wrap = true },
            -- size = { row = 9999, col = 9999 },
          },
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
  },
  {
    "LZDQ/nvim-autocenter",
    version = "*",
    opts = {
      -- auto center only when the cursor is not within this range vertically
      ratio_top = 1 / 3,
      ratio_bot = 2 / 3,
      -- When to call `autozz`. Choose between 'always', 'empty', and 'never'.
      -- 'always' means to always do autozz when buffer text changes.
      -- 'empty'  means to do autozz only when the current line contains whitespaces.
      -- 'never'  means do not autozz. If you choose never, you should enable autopairs.
      when = "empty",
      -- plugin support
      plugins = {
        -- auto center when pressing enter inside specific brackets
        autopairs = {
          enabled = true,
          -- These are rules to auto center when pressing enter after it.
          -- Each item is the lhs of the rule.
          rules_with_cr = {
            "{",
            "'''",
            '"""',
          },
        },
      },
    },
  },
}
