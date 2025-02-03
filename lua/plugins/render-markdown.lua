return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    file_types = { "markdown", "noice" },
    overrides = {
      filetype = {
        noice = {
          enabled = true,
          anti_conceal = {
            enabled = false,
          },
          win_options = {
            -- See :h 'conceallevel'
            conceallevel = {
              -- Used when not being rendered, get user setting
              default = 3,
              -- Used when being rendered, concealed text is completely hidden
              rendered = 3,
            },
            -- See :h 'concealcursor'
            concealcursor = {
              -- Used when not being rendered, get user setting
              default = "nvic",
              -- Used when being rendered, disable concealing text in all modes
              rendered = "nvic",
            },
          },
        },
        markdown = {
          enabled = true,
          win_options = {
            -- See :h 'conceallevel'
            conceallevel = {
              -- Used when not being rendered, get user setting
              default = 3,
              -- Used when being rendered, concealed text is completely hidden
              rendered = 3,
            },
            -- See :h 'concealcursor'
            concealcursor = {
              -- Used when not being rendered, get user setting
              default = "nvc",
              -- Used when being rendered, disable concealing text in all modes
              rendered = "nvc",
            },
          },
        },
      },
    },
  },
}
