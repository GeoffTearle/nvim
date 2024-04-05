---@class keymapManager
---@nodoc
local keymapManager = {}
-- general keybindings

function keymapManager.general()
  local keymap = vim.keymap.set
  local default_opts = { noremap = true, silent = true }
  local expr_opts = { noremap = true, expr = true, silent = true }

  local map = vim.keymap.set

  -- clear leader
  keymap({ "n", "v" }, "<Space>", "<Nop>", default_opts)

  keymap("n", "<C-Space>", "<Nop>", default_opts)
  keymap("n", "<C-Leader>", "<Nop>", default_opts)

  -- Yanking a line should act like D and C
  keymap("n", "Y", "y$", default_opts)

  keymap("n", "<Leader>;", "A;", default_opts)

  keymap("n", "J", "<Nop>", default_opts)

  -- better up/down
  -- Remap for dealing with word wrap
  map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
  map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
  map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

  -- Move to window using the <ctrl> hjkl keys
  map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
  map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
  map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
  map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

  -- Resize window using <ctrl> arrow keys
  map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
  map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
  map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
  map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

  -- Move Lines
  map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
  map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
  map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
  map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
  map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
  map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

  -- buffers
  map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
  map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
  map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
  map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

  -- Clear search with <esc>
  map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

  -- Clear search, diff update and redraw
  -- taken from runtime/lua/_editor.lua
  map(
    "n",
    "<leader>ur",
    "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
    { desc = "Redraw / clear hlsearch / diff update" }
  )

  -- Center search results
  -- keymap("n", "n", "nzz", default_opts)
  -- keymap("n", "N", "Nzz", default_opts)

  -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
  map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
  map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })

  map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
  map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
  map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

  -- Add undo break-points
  map("i", ",", ",<c-g>u")
  map("i", ".", ".<c-g>u")
  map("i", ";", ";<c-g>u")

  -- save file
  map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

  --keywordprg
  map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

  -- Better indent
  keymap("v", "<", "<gv", default_opts)
  keymap("v", ">", ">gv", default_opts)

  -- lazy
  map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

  -- new file
  map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

  map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
  map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

  map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
  map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

  -- formatting
  -- TODO: fix this
  -- map({ "n", "v" }, "<leader>cf", function()
  --   Util.format({ force = true })
  -- end, { desc = "Format" })

  -- TODO: Review these
  -- -- Diagnostic keymaps
  -- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
  -- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
  -- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
  -- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

  -- diagnostic
  local diagnostic_goto = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
      go({ severity = severity })
    end
  end

  map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
  map("n", "<leader>d", diagnostic_goto(true), { desc = "Next Diagnostic" })
  map("n", "<leader>D", diagnostic_goto(false), { desc = "Prev Diagnostic" })
  map("n", "<leader>e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
  map("n", "<leader>E", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
  map("n", "<leader>w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
  map("n", "<leader>W", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

  -- stylua: ignore start

  -- toggle options
  -- TODO: Review if needed
  -- map("n", "<leader>uf", function() Util.format.toggle() end, { desc = "Toggle auto format (global)" })
  -- map("n", "<leader>uF", function() Util.format.toggle(true) end, { desc = "Toggle auto format (buffer)" })
  -- map("n", "<leader>us", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
  -- map("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
  -- map("n", "<leader>uL", function() Util.toggle("relativenumber") end, { desc = "Toggle Relative Line Numbers" })
  -- map("n", "<leader>ul", function() Util.toggle.number() end, { desc = "Toggle Line Numbers" })
  -- map("n", "<leader>ud", function() Util.toggle.diagnostics() end, { desc = "Toggle Diagnostics" })
  -- local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
  -- map("n", "<leader>uc", function() Util.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })
  -- if vim.lsp.inlay_hint then
  --   map("n", "<leader>uh", function() vim.lsp.inlay_hint(0, nil) end, { desc = "Toggle Inlay Hints" })
  -- end
  -- map("n", "<leader>uT", function() if vim.b.ts_highlight then vim.treesitter.stop() else vim.treesitter.start() end end, { desc = "Toggle Treesitter Highlight" })

  -- lazygit
  -- TODO: fix this
  -- map("n", "<leader>gg", function() Util.terminal({ "lazygit" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false }) end, { desc = "Lazygit (root dir)" })
  -- map("n", "<leader>gG", function() Util.terminal({ "lazygit" }, {esc_esc = false, ctrl_hjkl = false}) end, { desc = "Lazygit (cwd)" })

  -- quit
  map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

  -- highlights under cursor
  map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

  -- floating terminal
  -- TODO: fix this
  -- local lazyterm = function() Util.terminal(nil, { cwd = Util.root() }) end
  -- map("n", "<leader>ft", lazyterm, { desc = "Terminal (root dir)" })
  -- map("n", "<leader>fT", function() Util.terminal() end, { desc = "Terminal (cwd)" })
  -- map("n", "<c-/>", lazyterm, { desc = "Terminal (root dir)" })
  -- map("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

  -- Terminal Mappings
  map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
  map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
  map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
  map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
  map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
  map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
  map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

  -- windows
  map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
  map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
  map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
  map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

  -- tabs
  map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
  map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
  map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
  map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
  map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
  map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
end

function keymapManager.telescope()
  -- See `:help telescope.builtine
  vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
  vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
  vim.keymap.set("n", "<leader>/", function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
      winblend = 10,
      previewer = false,
    }))
  end, { desc = "[/] Fuzzily search in current buffer" })

  vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files, { desc = "Search [G]it [F]iles" })
  vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
  vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
  vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
  vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
  vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
end

function keymapManager.lsp() end

function keymapManager.neotest()
  return {
    {
      "<leader>tt",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Run File",
    },
    {
      "<leader>tT",
      function()
        require("neotest").run.run(vim.uv.cwd())
      end,
      desc = "Run All Test Files",
    },
    {
      "<leader>tr",
      function()
        require("neotest").run.run()
      end,
      desc = "Run Nearest",
    },
    {
      "<leader>tl",
      function()
        require("neotest").run.run_last()
      end,
      desc = "Run Last",
    },
    {
      "<leader>ts",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Toggle Summary",
    },
    {
      "<leader>to",
      function()
        require("neotest").output.open({ enter = true, auto_close = true })
      end,
      desc = "Show Output",
    },
    {
      "<leader>tO",
      function()
        require("neotest").output_panel.toggle()
      end,
      desc = "Toggle Output Panel",
    },
    {
      "<leader>tS",
      function()
        require("neotest").run.stop()
      end,
      desc = "Stop",
    },
  }
end

return keymapManager
