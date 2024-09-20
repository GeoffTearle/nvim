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
            Statement = { fg = colors.pink },
            Conditional = { fg = colors.pink }, --  if, then, else, endif, switch, etc.
            Repeat = { fg = colors.pink },      --   for, do, while, etc.
            Label = { fg = colors.pink },       --    case, default, etc.
            ["@keyword.conditional"] = { link = "Conditional" },
            ["@keyword.repeat"] = { link = "Repeat" },
            ["@repeat"] = { link = "Repeat" },
            ["@variable.parameter"] = { fg = colors.orange }, -- For parameters of a function.
            ["@parameter"] = { fg = colors.orange },
            ["@parameter.reference"] = { fg = colors.orange },
            ["@variable.parameter.reference"] = { fg = colors.orange },
            ["@lsp.type.parameter"] = { fg = colors.orange },
          }
        end,
      })

      vim.cmd.colorscheme("one_monokai")
    end,
  }
end

if scheme == "monokai-pro" then
  return {
    "loctvl842/monokai-pro.nvim",
    priority = 1000,
    config = function()
      require("monokai-pro").setup({
        filter = "pro",
      })
      vim.cmd.colorscheme("monokai-pro")
    end,
  }
end

if scheme == "eldritch" then
  return {
    "eldritch-theme/eldritch.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd.colorscheme("eldritch")
    end,
  }
end

if scheme == "kurayami" then
  return {
    "kevinm6/kurayami.nvim",
    event = "VimEnter", -- load plugin on VimEnter or
    -- lazy = false,                  --   don't lazy load plugin
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("kurayami") -- this is enough to initialize and load plugin
    end,
  }
end

if scheme == "cyberdream" then
  return {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        -- Recommended - see "Configuring" below for more config options
        italic_comments = true,
        hide_fillchars = true,
        borderless_telescope = true,
        terminal_colors = true,
      })
      vim.cmd("colorscheme cyberdream") -- set the colorscheme
    end,
  }
end

if scheme == "monokai-nightasty" then
  return {
    "polirritmico/monokai-nightasty.nvim",
    lazy = false,
    priority = 1000,
    config = function(_, opts)
      -- Highlight line at the cursor position
      vim.opt.cursorline = true

      -- Default to dark theme
      vim.o.background = "dark" -- dark | light

      require("monokai-nightasty").load(opts)
      vim.cmd("colorscheme monokai-nightasty") -- set the colorscheme
    end,
  }
end
