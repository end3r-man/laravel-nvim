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
				desc = "Format buffer",
			},
		},
		opts = {
			log_level = vim.log.levels.WARN,
			formatters = {
				prettier = {
					prepend_args = { "--ignore-unknown" },
				},
				["php-cs-fixer"] = {
					command = "php-cs-fixer",
					args = {
						"fix",
						"--rules=@PSR12", -- Formatting preset. Other presets are available, see the php-cs-fixer docs.
						"$FILENAME",
					},
					stdin = false,
				},
			},
			formatters_by_ft = {
				blade = { "blade-formatter" },
				lua = { "stylua" },
				javascript = { "prettierd", "prettier" },
				json = { "prettierd", "prettier" },
				fish = { "fish_indent" },
				sh = { "shfmt" },
				php = { "pint", "phpcbf", "php_cs_fixer" },
				vue = { "prettierd", "prettier" },
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

	-- Blade navigation plugin
	{
		"ricardoramirezr/blade-nav.nvim",
		dependencies = { "hrsh7th/nvim-cmp" },
		ft = { "blade", "php" }, -- Optional, improves startup time
	},
}
