return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
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
			"python",
			"query",
			"regex",
			"vim",
			"yaml",
			"php",
		},
		auto_install = true,
	},
	config = function(_, opts)
		-- Setup nvim-treesitter with the options
		require("nvim-treesitter.configs").setup(opts)

		-- Add filetype patterns
		vim.filetype.add({
			pattern = {
				[".*%.blade%.php"] = "blade",
			},
		})

		-- Optionally configure the parser for blade
		-- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
		-- parser_config.blade = {
		--   install_info = {
		--     url = "https://github.com/EmranMR/tree-sitter-blade",
		--     files = { "src/parser.c" },
		--     branch = "main",
		--   },
		--   filetype = "blade",
		-- }
	end,
}
