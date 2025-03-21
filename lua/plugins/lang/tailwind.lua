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
				server = {
					override = true,
					settings = {
						tailwindCSS = {
							experimental = {
								classRegex = {
									{ 'class[:]\\s*"([^"]*)"', 1 },
									{ '~H"([^"]*)"', 1 },
								},
							},
						},
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
		end,
	},
}
