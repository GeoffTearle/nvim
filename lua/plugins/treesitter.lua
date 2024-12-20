if false then
  return {}
end

return {
  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
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
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "typescript", "html" },
        highlight = { enable = true },
        indent = { enable = true },

        autotag = {
          enable = true,
        },
      })

      vim.filetype.add({
        pattern = {
          [".*/hypr/.*%.conf"] = "hyprlang",
          [".*/git/.*%.config"] = "gitconfig",
        },
      })
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
  },
}
