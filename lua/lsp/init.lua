return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local lsp_attach_group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true })
		vim.api.nvim_create_autocmd("LspAttach", {
			group = lsp_attach_group,
			callback = function(ev)
				local buf = ev.buf
				local function map(keys, fn, desc)
					vim.keymap.set("n", keys, fn, { buffer = buf, desc = desc })
				end
				map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
				map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
				map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
				map("K", vim.lsp.buf.hover, "Show hover")
			end,
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		local servers = require("lsp.servers") -- points at lua/config/server/init.lua
		local ensure = vim.tbl_keys(servers)

		require("mason-lspconfig").setup({
			ensure_installed = ensure,
			handlers = {
				function(name)
					local cfg = {
						capabilities = capabilities,
					}
					local ok, server_mod = pcall(require, "config.lsp.servers." .. name)
					if ok and type(server_mod) == "table" then
						vim.tbl_deep_extend("force", cfg, server_mod)
					end
					require("lspconfig")[name].setup(cfg)
				end,
			},
		})
	end,
}
