local next_hunk = function()
  require("gitsigns").nav_hunk("next")
end

local prev_hunk = function()
  require("gitsigns").nav_hunk("prev")
end

return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  "lewis6991/gitsigns.nvim",
  opts = {
    -- See `:help gitsigns.txt`
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    on_attach = function(bufnr)
      vim.keymap.set("n", "<leader>gp", prev_hunk, { buffer = bufnr, desc = "[G]o to [P]revious Hunk" })
      vim.keymap.set("n", "<leader>gn", next_hunk, { buffer = bufnr, desc = "[G]o to [N]ext Hunk" })
      vim.keymap.set("n", "<leader>ph", require("gitsigns").preview_hunk, { buffer = bufnr, desc = "[P]review [H]unk" })
    end,
  },
}
