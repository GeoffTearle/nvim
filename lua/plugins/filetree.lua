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

		vim.keymap.set('n', '\\', ':Neotree reveal<CR>', { silent = true })

		require("neo-tree").setup({
			enable_git_status = true,
			enable_diagnostics = true,
			window = {
				position = "float",
				popup = {
					position = { col = "100%", row = "2" },
					size = function(state)
						local root_name = vim.fn.fnamemodify(state.path, ":~")
						local root_len = string.len(root_name) + 4
						return {
							width = math.max(root_len, 50),
							height = vim.o.lines - 2,
						}
					end
				},
				mappings = {
					['\\'] = 'cancel',
				},
			},
			filesystem = {
				filtered_items = {
					visible = false,
					hide_dotfiles = false,
					hide_gitignored = true,
					hide_hidden = true,
					never_show = {
						'.git',
					},
				},
				follow_current_file = {
					enabled = true,
					leave_dirs_open = false,
				},
			}
		})
	end,
}
