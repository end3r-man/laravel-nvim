return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false, -- load on startup
	init = function(plugin)
		-- Ensure the plugin's runtime files are available before config runs
		require("lazy.core.loader").add_to_rtp(plugin)
		-- Preload custom query predicates, useful for dependent plugins
		require("nvim-treesitter.query_predicates")
	end,
	opts = {
		ensure_installed = {
			"bash",
			"blade",
			"html",
			"javascript",
			"json",
			"lua",
			"markdown",
			"markdown_inline",
			"query",
			"regex",
			"vim",
			"yaml",
			"php",
			"vue",
			"typescript",
		},
		auto_install = true,
		highlight = { enable = true },
		indent = { enable = true },
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)

		vim.filetype.add({
			pattern = {
				[".*%.blade%.php"] = "blade",
			},
		})
	end,
}
