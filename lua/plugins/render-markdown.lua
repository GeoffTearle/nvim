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
          code = {
            -- Turn on / off code block & inline code rendering
            enabled = true,
          },
          win_options = {
            -- See :h 'conceallevel'
            conceallevel = {
              default = 0,
              rendered = 0,
            },
            -- See :h 'concealcursor'
            concealcursor = {
              default = "nvic",
              rendered = "nvic",
            },
          },
        },
        markdown = {
          enabled = true,
          win_options = {
            -- See :h 'conceallevel'
            conceallevel = {
              default = 0,
              rendered = 0,
            },
            -- See :h 'concealcursor'
            concealcursor = {
              default = "nvic",
              rendered = "nvic",
            },
          },
        },
      },
    },
  },
}
