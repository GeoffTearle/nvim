local icons = require("config.icons").diagnostics

---@class optionsManager
---@nodoc
local optionsManager = {}

function optionsManager.apply()
  vim.loader.enable()
  -- Set <space> as the leader key
  -- See `:help mapleader`
  --  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "

  local opt = vim.opt
  opt.autoindent = true -- copy indent from current line when starting a new line
  opt.autowrite = true -- Automatically save before :next, :make etc.
  opt.breakindent = true -- Enable break indent
  opt.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim.
  opt.completeopt = "menu,menuone,noselect"
  opt.conceallevel = 3 -- Hide * markup for bold and italic
  opt.confirm = true -- Confirm to save changes before exiting modified buffer
  opt.cursorline = true -- Enable highlighting of the current line
  opt.expandtab = true -- Use spaces instead of tabs
  opt.fillchars = {
    foldopen = "",
    foldclose = "",
    -- fold = "⸱",
    fold = " ",
    foldsep = " ",
    diff = "╱",
    eob = " ",
  }
  opt.foldlevel = 99
  opt.foldmethod = "indent"
  opt.formatoptions = "jcroqlnt" -- tcqj
  opt.grepformat = "%f:%l:%c:%m"
  opt.grepprg = "rg --vimgrep"
  opt.hlsearch = false -- Set highlight on search
  opt.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search
  opt.inccommand = "nosplit" -- preview incremental substitute
  opt.laststatus = 3 -- global statusline
  opt.list = true -- Show some invisible characters (tabs...
  opt.mouse = "a" -- Enable mouse mode
  opt.number = true -- Print line number
  opt.pumblend = 10 -- Popup blend
  opt.pumheight = 10 -- Maximum number of entries in a popup
  opt.relativenumber = true -- Relative line numbers
  opt.scrolloff = 7 -- Lines of context
  opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
  opt.shiftround = true -- Round indent
  opt.shiftwidth = 2 -- number of spaces to use for each step of indent.
  opt.shortmess:append({ W = true, I = true, c = true, C = true })
  opt.showmatch = true -- Highlight matching parenthesis
  opt.showmode = false -- Dont show mode since we have a statusline
  opt.sidescrolloff = 8 -- Columns of context
  opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
  opt.smartcase = true -- Case-insensitive searching UNLESS \C or capital in search
  opt.smartindent = true -- Insert indents automatically
  opt.spelllang = { "en" }
  opt.splitbelow = true -- Put new windows below current
  opt.splitkeep = "screen"
  opt.splitright = true -- Put new windows right of current
  opt.swapfile = false
  opt.tabstop = 2 -- Number of spaces tabs count for
  opt.termguicolors = true -- True color support
  opt.timeoutlen = 300 -- Decrease update time
  opt.undodir = vim.fn.stdpath("data") .. "undo"
  opt.undofile = true -- Save undo history
  opt.undolevels = 10000
  opt.updatetime = 200 -- Save swap file and trigger CursorHold
  opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
  opt.wildmode = "longest:full,full" -- Command-line completion mode
  opt.winminwidth = 5 -- Minimum window width
  opt.wrap = true -- Enable line wrap

  vim.wo.signcolumn = "yes" -- Keep signcolumn on by default

  vim.g.markdown_recommended_style = 0
  vim.o.pumblend = 20

  vim.fn.sign_define("DiagnosticSignError", { text = icons.Error, texthl = "DiagnosticSignError" })
  vim.fn.sign_define("DiagnosticSignWarn", { text = icons.Warn, texthl = "DiagnosticSignWarn" })
  vim.fn.sign_define("DiagnosticSignInfo", { text = icons.Info, texthl = "DiagnosticSignInfo" })
  vim.fn.sign_define("DiagnosticSignHint", { text = icons.Hint, texthl = "DiagnosticSignHint" })
end

return optionsManager
