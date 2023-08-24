-- [[ NeoTree ]]
--
-- NOTE: Requires fd to be installed to make search work
--
-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function()
    vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
    vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
    vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
    vim.fn.sign_define('DiagnosticSignHint', { text = '󰌵', texthl = 'DiagnosticSignHint' })

    vim.keymap.set('n', '\\', ':Neotree reveal<CR>')

    require("neo-tree").setup({
      window = {
        position = "float",
        popup = {
          position = { col = "100%", row = "2" },
          size = function(state)
            local root_name = vim.fn.fnamemodify(state.path, ":~")
            local root_len = string.len(root_name) + 4
            return {
              width = math.max(root_len, 50),
              height = vim.o.lines - 4
            }
          end
        },
        mappings = {
          ['\\'] = 'cancel',
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_hidden = true,
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
      }
    })
    -- require('neo-tree').setup {
    --   enable_git_status = true,
    --   enable_diagnostics = true,
    --   enable_normal_mode_for_inputs = false,                             -- Enable normal mode for input dialogs.
    --   open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' }, -- when opening files, do not use windows containing these filetypes or buftypes
    --   -- window = {
    --   --   position = 'right',
    --   --
    --   --   mapping_options = {
    --   --     noremap = true,
    --   --     nowait = true,
    --   --   },
    --   --
    --   --   mappings = {
    --   --     ['<space>'] = {
    --   --       'toggle_node',
    --   --       nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
    --   --     },
    --   --     ['<2-LeftMouse>'] = 'open',
    --   --     ['<cr>'] = 'open',
    --   --     ['<esc>'] = 'cancel', -- close preview or floating neo-tree window
    --   --     ['P'] = { 'toggle_preview', config = { use_float = true } },
    --   --     ['l'] = 'focus_preview',
    --   --     ['S'] = 'open_split',
    --   --     ['s'] = 'open_vsplit',
    --   --     -- ["S"] = "split_with_window_picker",
    --   --     -- ["s"] = "vsplit_with_window_picker",
    --   --     ['t'] = 'open_tabnew',
    --   --     -- ["<cr>"] = "open_drop",
    --   --     -- ["t"] = "open_tab_drop",
    --   --     ['w'] = 'open_with_window_picker',
    --   --     --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
    --   --     ['C'] = 'close_node',
    --   --     -- ['C'] = 'close_all_subnodes',
    --   --     ['z'] = 'close_all_nodes',
    --   --     --["Z"] = "expand_all_nodes",
    --   --     ['a'] = {
    --   --       'add',
    --   --       -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
    --   --       -- some commands may take optional config options, see `:h neo-tree-mappings` for details
    --   --       config = {
    --   --         show_path = 'none', -- "none", "relative", "absolute"
    --   --       },
    --   --     },
    --   --     ['A'] = 'add_directory', -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
    --   --     ['d'] = 'delete',
    --   --     ['r'] = 'rename',
    --   --     ['y'] = 'copy_to_clipboard',
    --   --     ['x'] = 'cut_to_clipboard',
    --   --     ['p'] = 'paste_from_clipboard',
    --   --     ['c'] = 'copy', -- takes text input for destination, also accepts the optional config.show_path option like "add":
    --   --     -- ["c"] = {
    --   --     --  "copy",
    --   --     --  config = {
    --   --     --    show_path = "none" -- "none", "relative", "absolute"
    --   --     --  }
    --   --     --}
    --   --     ['m'] = 'move', -- takes text input for destination, also accepts the optional config.show_path option like "add".
    --   --     ['q'] = 'close_window',
    --   --     ['R'] = 'refresh',
    --   --     ['?'] = 'show_help',
    --   --     ['<'] = 'prev_source',
    --   --     ['>'] = 'next_source',
    --   --   },
    --   -- },
    --
    --   filesystem = {
    --     filtered_items = {
    --       visible = false, -- when true, they will just be displayed differently than normal items
    --       hide_dotfiles = false,
    --       hide_gitignored = true,
    --       hide_hidden = true, -- only works on Windows for hidden files/directories
    --     },
    --     follow_current_file = {
    --       enabled = false,                      -- This will find and focus the file in the active buffer every time
    --       --               -- the current file is changed while the tree is open.
    --       leave_dirs_open = false,              -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    --     },
    --     group_empty_dirs = false,               -- when true, empty folders will be grouped together
    --     hijack_netrw_behavior = 'open_default', -- netrw disabled, opening a directory opens neo-tree
    --     -- in whatever position is specified in window.position
    --     -- "open_current",  -- netrw disabled, opening a directory opens within the
    --     -- window like netrw would, regardless of window.position
    --     -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
    --     use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
    --     -- instead of relying on nvim autocmd events.
    --     window = {
    --       popup = {
    --         position = { col = "100%", row = "2" },
    --         size = function(state)
    --           local root_name = vim.fn.fnamemodify(state.path, ":~")
    --           local root_len = string.len(root_name) + 4
    --           return {
    --             width = math.max(root_len, 50),
    --             height = vim.o.lines - 6
    --           }
    --         end
    --       },
    --       mappings = {
    --         ['<bs>'] = 'navigate_up',
    --         ['.'] = 'set_root',
    --         ['H'] = 'toggle_hidden',
    --         ['/'] = 'fuzzy_finder',
    --         ['D'] = 'fuzzy_finder_directory',
    --         ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the fzy algorithm
    --         -- ["D"] = "fuzzy_sorter_directory",
    --         ['f'] = 'filter_on_submit',
    --         ['<c-x>'] = 'clear_filter',
    --         ['[g'] = 'prev_git_modified',
    --         [']g'] = 'next_git_modified',
    --       },
    --       fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
    --         ['<down>'] = 'move_cursor_down',
    --         ['<C-n>'] = 'move_cursor_down',
    --         ['<up>'] = 'move_cursor_up',
    --         ['<C-p>'] = 'move_cursor_up',
    --       },
    --     },
    --
    --     -- commands = {}, -- Add a custom command or override a global one using the same function name
    --   },
    -- }
  end,
}
