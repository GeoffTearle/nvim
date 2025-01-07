local icons = require("config.icons").diagnostics

return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        close_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
        right_mouse_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diagnostics_dict, _)
          local error = ""
          local warning = ""
          local info = ""
          local hint = ""
          local unknown = ""
          for e, n in pairs(diagnostics_dict) do
            if e == "error" then
              error = n .. icons.Error
              goto continue
            end
            if e == "warning" then
              warning = n .. icons.Warn
              goto continue
            end
            if e == "info" then
              info = n .. icons.Info
              goto continue
            end
            if e == "hint" then
              hint = n .. icons.Hint
              goto continue
            end
              unknown = n .. icons.Unknown
              ::continue::
          end
          return error .. warning .. info .. hint .. unknown
        end,
      },
    },
    config = function(_, opts)
      vim.opt.termguicolors = true
      require("bufferline").setup(opts)
    end,
  },
  -- buffer remove
  {
    "echasnovski/mini.bufremove",

    keys = {
      {
        "<leader>bd",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Delete Buffer",
      },
      -- stylua: ignore
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },
}
