local slow_format_filetypes = {
	injected = true,
}

return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true, timeout_ms = 5000 })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = {
			log_level = vim.log.levels.WARN,
			formatters = {
				prettier = {
					prepend_args = { "--ignore-unknown" },
				},
			},
			formatters_by_ft = {
				blade = { "blade-formatter", stop_after_first = true },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				php = { "pint", "phpcbf", "php_cs_fixer", stop_after_first = true },
			},
			format_on_save = function(bufnr)
				if slow_format_filetypes[vim.bo[bufnr].filetype] then
					return
				end
				local function on_format(err)
					if err and err:match("timeout$") then
						slow_format_filetypes[vim.bo[bufnr].filetype] = true
					end
				end

				return { timeout_ms = 5000, lsp_fallback = true }, on_format
			end,
			format_after_save = function(bufnr)
				if slow_format_filetypes[vim.bo[bufnr].filetype] then
					return
				end
				return { timeout_ms = 5000, lsp_fallback = true }
			end,
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
