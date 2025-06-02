return {
	-- Blade syntax highlighting
	{ "jwalton512/vim-blade" },

	-- Blade navigation plugin
	{
		"ricardoramirezr/blade-nav.nvim",
		dependencies = { "hrsh7th/nvim-cmp" },
		ft = { "blade", "php" },
	},
}
