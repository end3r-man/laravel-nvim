return {
	{
		"jayp0521/mason-null-ls.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		},
		config = function()
			local mason_null_ls = require("mason-null-ls")
			local null_ls = require("null-ls")

			mason_null_ls.setup({
				ensure_installed = {
					"prettier", -- TS/JS formatter
					"stylua", -- Lua formatter
					"shfmt", -- Shell formatter
					"blade-formatter", -- Blade template formatter
					"eslint_d", -- JavaScript linter
					"markdownlint", -- Markdown linter
					"php-cs-fixer"
				},
				automatic_installation = true,
			})

			local sources = {
				-- Formatters
				null_ls.builtins.formatting.prettier.with({
					filetypes = { "html", "json", "yaml", "markdown", "js", "javascript", "typescript", "vue" },
				}),
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.shfmt.with({ args = { "-i", "4" } }),
				null_ls.builtins.formatting.blade_formatter.with({
					filetypes = { "blade" },
				}),
				null_ls.builtins.formatting.phpcsfixer,

				-- Linters
				null_ls.builtins.diagnostics.eslint_d.with({
					filetypes = { "javascript", "typescript" },
				}),
				null_ls.builtins.diagnostics.markdownlint,
			}

			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			null_ls.setup({
				sources = sources,
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ async = false })
							end,
						})
					end
				end,
			})
		end,
	},

	-- Blade syntax highlighting
	{ "jwalton512/vim-blade" },

	-- Blade navigation plugin
	{
		"ricardoramirezr/blade-nav.nvim",
		dependencies = { "hrsh7th/nvim-cmp" },
		ft = { "blade", "php" },
	},
}
