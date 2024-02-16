local scheme = "one_monokai"

if scheme == "catppuccin" then
  return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        term_colors = true,
        transparent_background = false,
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  }
end

if scheme == "flexoki" then
  return {
    "stevedylandev/flexoki-nvim",
    name = "flexoki",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("flexoki")
    end,
  }
end

if scheme == "one_monokai" then
  return {
    "cpea2506/one_monokai.nvim",
    priority = 1000,
    config = function()
      require("one_monokai").setup({
        italics = false, -- disable italics
        themes = function(colors)
          return {
            Statement                         = { fg = colors.pink },
            Conditional                       = { fg = colors.pink }, --  if, then, else, endif, switch, etc.
            Repeat                            = { fg = colors.pink }, --   for, do, while, etc.
            Label                             = { fg = colors.pink }, --    case, default, etc.
            ["@keyword.conditional"]          = { link = "Conditional" },
            ["@keyword.repeat"]               = { link = "Repeat" },
            ["@repeat"]                       = { link = "Repeat" },
            ["@variable.parameter"]           = { fg = colors.orange }, -- For parameters of a function.
            ["@parameter"]                    = { fg = colors.orange },
            ["@parameter.reference"]          = { fg = colors.orange },
            ["@variable.parameter.reference"] = { fg = colors.orange },
            ['@lsp.type.parameter']           = { fg = colors.orange },
          }
        end
      })

      vim.cmd.colorscheme("one_monokai")
    end
  }
end

if scheme == "monokai-pro" then
  return {
    "loctvl842/monokai-pro.nvim",
    priority = 1000,
    config = function()
      require("monokai-pro").setup({
        filter = "pro"
      })
      vim.cmd.colorscheme("monokai-pro")
    end
  }
end
