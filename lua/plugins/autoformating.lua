return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim", -- Ensure dependencies are installed
	},
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics

		-- Setup mason-null-ls to ensure formatters and linters are installed
		require("mason-null-ls").setup({
			ensure_installed = {
				"prettier", -- TS/JS formatter
				"stylua", -- Lua formatter
				"shfmt", -- Shell formatter
				"blade-formatter", -- Blade template formatter
			},
			automatic_installation = true,
		})

		-- Define sources for formatters and linters
		local sources = {
			diagnostics.checkmake,
			formatting.prettier.with({
				filetypes = { "html", "json", "yaml", "markdown", "js", "javascript", "typescript" },
			}),
			formatting.stylua,
			formatting.shfmt.with({ args = { "-i", "4" } }),
		}

		-- Create an autogroup for LSP formatting
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		-- Setup null-ls with the defined sources and on_attach function
		null_ls.setup({
			-- debug = true, -- Uncomment to enable debug mode
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
}
