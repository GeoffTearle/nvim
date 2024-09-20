return {
  -- Set lualine as statusline
  "nvim-lualine/lualine.nvim",
  -- See `:help lualine.txt`
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "one_monokai",
        -- theme = "eldritch",
        -- theme = "monokai-nightasty",
        component_separators = "|",
        section_separators = "",
      },
    })
  end,
}
