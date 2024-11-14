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
      require("nvim-treesitter.configs").setup({
        -- Add languages to be installed here that you want installed for treesitter

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = true,
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          "csv",
          "dockerfile",
          "elvish",
          "gitcommit",
          "gitignore",
          "go",
          "gomod",
          "gosum",
          "gotmpl",
          "gowork",
          "hyprlang",
          "javascript",
          "json",
          "just",
          "kdl",
          "lua",
          "markdown",
          "markdown_inline",
          "nix",
          "proto",
          "python",
          "regex",
          "rust",
          "teal",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },

        highlight = { enable = true },
        indent = { enable = true },
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
}
