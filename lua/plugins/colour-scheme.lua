-- return {
-- 	'loctvl842/monokai-pro.nvim',
-- 	priority = 1000,
-- 	config = function()
-- 		require('monokai-pro').setup(
-- 			{
-- 				terminal_colors = true,
-- 				devicons = true, -- highlight the icons of `nvim-web-devicons`
-- 				styles = {
-- 					comment = { italic = true },
-- 					keyword = { italic = true }, -- any other keyword
-- 					type = { italic = true }, -- (preferred) int, long, char, etc
-- 					storageclass = { italic = true }, -- static, register, volatile, etc
-- 					structure = { italic = true }, -- struct, union, enum, etc
-- 					parameter = { italic = true }, -- parameter pass in function
-- 					annotation = { italic = true },
-- 					tag_attribute = { italic = true }, -- attribute of tag in reactjs
-- 				},
-- 				filter = "spectrum",    -- classic | octagon | pro | machine | ristretto | spectrum
-- 				plugins = {
--
-- 				}
-- 			}
-- 		)
-- 		vim.cmd.colorscheme 'monokai-pro'
-- 	end,
-- }

-- return {
-- 	'tanvirtin/monokai.nvim',
-- 	priority = 1000,
-- 	config = function()
-- 		local monokai = require('monokai')
-- 		local palette = monokai.pro
-- 		monokai.setup {
-- 			palette = palette
-- 		}
-- 		vim.cmd.colorscheme 'monokai'
-- 	end,
-- }
--
-- return {
--   'ray-x/starry.nvim',
--   priority = 1000,
--   config = function()
--     local starry = require 'starry'
--     starry.setup {}
--     vim.cmd.colorscheme 'monokai'
--   end,
-- }

-- return {
--   "cpea2506/one_monokai.nvim",
--   config = function()
--     require("one_monokai").setup({
--       -- your options
--     })
--   end,
-- }
--
-- return {
--   'Yazeed1s/minimal.nvim',
--   config = function()
--     vim.cmd.colorscheme 'minimal'
--   end
--
-- }

-- return {
--   'Yagua/nebulous.nvim',
--   config = function()
--     require("nebulous").setup {
--       variant = "fullmoon",
--       -- disable = {
--       --   background = false,
--       --   endOfBuffer = false,
--       --   terminal_colors = false,
--       -- },
--       -- italic = {
--       --   comments  = false,
--       --   keywords  = true,
--       --   functions = false,
--       --   variables = true,
--       -- },
--     }
--   end,
-- }

return {
	'sainnhe/sonokai',
	config = function()
		vim.cmd.colorscheme 'sonokai'
	end

}
