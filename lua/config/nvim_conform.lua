local slow_format_filetypes = {}

return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPost", "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({
						async = true,
						lsp_fallback = true,
						timeout_ms = 5000,
					})
				end,
				mode = "n",
				desc = "Format buffer",
			},
		},
		opts = {
			log_level = vim.log.levels.WARN,
			formatters_by_ft = {
				blade = { "blade-formatter", stop_after_first = true },
				vue = { "prettierd", stop_after_first = true },
				javascript = { "prettierd", stop_after_first = true },
				typescript = { "prettierd", stop_after_first = true },
				json = { "prettierd", "jq", stop_after_first = true },
				markdown = { "prettierd", "markdownlint", stop_after_first = true },
				lua = { "stylua" },
				php = { "pretty-php", "phpcbf", "php-cs-fixer", stop_after_first = true },
				sql = { "pg_format", "sqlfmt", stop_after_first = true },
				yaml = { "yamlfmt" },
				["*"] = { "injected" },
			},
			format_on_save = {
				timeout_ms = 5000,
				lsp_fallback = true,
				quiet = false,
			},
			format_after_save = {
				lsp_fallback = true,
				async = true,
			},
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},
	-- Blade syntax highlighting
	{ "jwalton512/vim-blade" },
	{
		-- Add the blade-nav.nvim plugin which provides Goto File capabilities
		-- for Blade files.
		"ricardoramirezr/blade-nav.nvim",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		ft = { "blade", "php" }, -- optional, improves startup time
	},
}
