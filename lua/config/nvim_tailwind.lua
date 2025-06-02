return {
	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		config = function()
			require("tailwind-tools").setup({
				document_color = {
					enabled = true,
					kind = "inline",
					inline_symbol = "󰝤 ",
				},
				conceal = {
					enabled = false,
					min_length = nil,
					symbol = "",
					highlight = {
						fg = "#38BDF8",
					},
				},
			})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"neovim/nvim-lspconfig",
		},
	},
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		config = function()
			require("tailwindcss-colorizer-cmp").setup({
				color_square_width = 2,
			})

			require("cmp").config.formatting = {
				format = require("tailwindcss-colorizer-cmp").formatter,
			}
		end,
	},
}
