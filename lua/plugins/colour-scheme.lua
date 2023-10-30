local scheme = "flexoki"

if scheme == "catppuccin" then
	return {
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require('catppuccin').setup({
				term_colors = true,
				transparent_background = false,
			})

			vim.cmd.colorscheme "catppuccin"
		end
	}
end

if scheme == "flexoki" then
	return {
		'stevedylandev/flexoki-nvim',
		name = 'flexoki',
		priority = 1000,
		config = function()
			vim.cmd.colorscheme "flexoki"
		end
	}
end
