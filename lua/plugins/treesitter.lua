return {
	-- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",

	-- [[ Configure Treesitter ]]
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
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = { "ruby" },
		},
		indent = { enable = true, disable = { "ruby" } },
	},

	config = function(_, opts)
		-- Extend the ensure_installed list
		vim.list_extend(opts.ensure_installed, {
			"blade",
		})

		-- Add filetype patterns
		vim.filetype.add({
			pattern = {
				[".*%.blade%.php"] = "blade",
			},
		})

		-- Setup nvim-treesitter with the options
		require("nvim-treesitter.configs").setup(opts)

		-- Configure the parser for blade
		local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
		parser_config.blade = {
			install_info = {
				url = "https://github.com/EmranMR/tree-sitter-blade",
				files = { "src/parser.c" },
				branch = "main",
			},
			filetype = "blade",
		}
	end,
}
