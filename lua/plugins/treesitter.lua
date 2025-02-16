if false then
  return {}
end

return {
  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dir = require("nix-treesitter-grammers").path,
    dev = true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      {
        "IndianBoy42/tree-sitter-just",
        config = function()
          require("tree-sitter-just").setup({})
        end,
      },
    },
    build = ":TSUpdate",
    config = function()
      -- [[ Configure Treesitter ]]
      -- See `:help nvim-treesitter`
      require("nvim-treesitter.configs").setup({
        -- ensure_installed = "all",
        highlight = { enable = true },
        indent = { enable = true },

        autotag = {
          enable = false,
        },
      })

      vim.filetype.add({
        pattern = {
          [".*/hypr/.*%.conf"] = "hyprlang",
          [".*/git/.*%.config"] = "gitconfig",
        },
      })
      vim.treesitter.language.register("markdown", "noice")
    end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
        languages = {
          kdl = "// %s",
        },
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    lazy = false,
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {

          -- Defaults
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false, -- Auto close on trailing </
        },
        -- Also override individual filetype configs, these take priority.
        -- Empty by default, useful if one of the "opts" global settings
        -- doesn't work well in a specific filetype
        per_filetype = {
          ["html"] = {
            enable_close = false,
          },
        },
      })
    end,
  },
}
