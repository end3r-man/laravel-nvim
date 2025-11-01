return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- Setup blade filetype detection
		vim.filetype.add({
			pattern = {
				[".*%.blade%.php"] = "blade",
			},
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- Create LSP attach autocommand group
		local lsp_attach_group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true })

		vim.api.nvim_create_autocmd("LspAttach", {
			group = lsp_attach_group,
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				local buf = ev.buf

				local function map(keys, fn, desc)
					vim.keymap.set("n", keys, fn, { buffer = buf, desc = desc })
				end

				-- LSP Keymaps
				map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
				map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
				map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
				map("K", vim.lsp.buf.hover, "Show hover")
				map("<leader>d", vim.diagnostic.open_float, "Show [D]iagnostics")
			end,
		})

		-- Load server configurations
		local servers = require("lsp.servers")

		-- Configure each LSP server using the new vim.lsp.config() API
		for server_name, server_config in pairs(servers) do
			local config = vim.tbl_deep_extend("force", {
				capabilities = capabilities,
			}, server_config)

			vim.lsp.config(server_name, config)
		end

		-- Enable all configured LSP servers
		local server_names = vim.tbl_keys(servers)
		vim.lsp.enable(server_names)

		-- Setup Mason for installing LSP servers and tools
		local ensure_installed = vim.list_extend(vim.deepcopy(server_names), {
			"stylua", -- Lua
			"prettierd", -- JS/TS/Vue/JSON
			"blade-formatter", -- Blade
			"php-cs-fixer", -- PHP
			"pint", -- Laravel PHP
		})

		require("mason-tool-installer").setup({
			ensure_installed = ensure_installed,
			auto_update = false,
			run_on_start = true,
		})
	end,
}
