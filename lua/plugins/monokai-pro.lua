return {
  'loctvl842/monokai-pro.nvim',
  priority = 1000,
  config = function()
    require('monokai-pro').setup(
      {
        terminal_colors = true,
        devicons = true, -- highlight the icons of `nvim-web-devicons`
        styles = {
          comment = { italic = true },
          keyword = { italic = true },       -- any other keyword
          type = { italic = true },          -- (preferred) int, long, char, etc
          storageclass = { italic = true },  -- static, register, volatile, etc
          structure = { italic = true },     -- struct, union, enum, etc
          parameter = { italic = true },     -- parameter pass in function
          annotation = { italic = true },
          tag_attribute = { italic = true }, -- attribute of tag in reactjs
        },
        filter = "pro",                      -- classic | octagon | pro | machine | ristretto | spectrum
      }
    )
    vim.cmd.colorscheme 'monokai-pro'
  end,
}
