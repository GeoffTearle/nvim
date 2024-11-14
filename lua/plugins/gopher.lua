return {
  "olexsmir/gopher.nvim",
  ft = "go",
  -- branch = "develop", -- if you want develop branch
  -- keep in mind, it might break everything
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  ---@type gopher.Config
  opts = {},
}
