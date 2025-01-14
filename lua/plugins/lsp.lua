return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true }, -- Ensure mason is set up
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- Create an autocommand group for LSP attachment
		local lsp_attach_group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true })
		local mason_registry = require("mason-registry")
		local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
			.. "/node_modules/@vue/language-server"

		-- LSP Attach Autocommand
		vim.api.nvim_create_autocmd("LspAttach", {
			group = lsp_attach_group,
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				local bufnr = event.buf -- Get the buffer number from the event

				-- Helper function for key mappings
				local function map(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
				end

				-- Key mappings for LSP functions
				map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
				map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
				map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
			end,
		})

		-- Set up capabilities for LSP clients
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- Define LSP servers and their settings
		local servers = {
			html = { filetypes = { "html", "twig", "hbs", "blade" } },
			cssls = {},
			tailwindcss = { filetypes = { "blade", "vue" } },
			jsonls = {},
			yamlls = {},
			lua_ls = {
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = {
								"${3rd}/luv/library",
								unpack(vim.api.nvim_get_runtime_file("", true)),
							},
						},
						diagnostics = { disable = { "missing-fields" } },
						format = { enable = false },
					},
				},
			},
			--	volar = {
			--		init_options = {
			--			vue = {
			--				hybridMode = true,
			--			},
			--		},
			--	},
			--	vtsls = {},
			ts_ls = {
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
				init_options = {
					plugins = {
						{
							name = "@vue/typescript-plugin",
							location = vim.fn.stdpath("data")
								.. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
							languages = { "vue" },
						},
					},
				},
			},
		}

		-- Ensure required tools are installed
		local ensure_installed = vim.tbl_keys(servers)
		vim.list_extend(ensure_installed, { "stylua" }) -- Used to format Lua code
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		-- Setup mason-lspconfig with handlers for each server
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})

		require("lspconfig").phpactor.setup({
			on_attach = function(client, bufnr)
				-- Custom on_attach function for PHP Actor
				-- Example: vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap=true, silent=true })
			end,
			init_options = {
				["language_server.diagnostics_on_update"] = false,
				["language_server.diagnostics_on_open"] = true,
				["language_server.diagnostics_on_save"] = true,
				["language_server_phpstan.enabled"] = true,
				["language_server_psalm.enabled"] = true,
			},
		})

		-- Emmet Language Server setup
		require("lspconfig").emmet_language_server.setup({
			filetypes = {
				"css",
				"eruby",
				"html",
				"javascript",
				"javascriptreact",
				"less",
				"sass",
				"scss",
				"pug",
				"typescriptreact",
				"blade",
				"vue",
			},
			init_options = {
				includeLanguages = {},
				excludeLanguages = {},
				extensionsPath = {},
				preferences = {},
				showAbbreviationSuggestions = true,
				showExpandedAbbreviation = "always",
				showSuggestionsAsSnippets = false,
				syntaxProfiles = {},
				variables = {},
			},
		})

		require("lspconfig").ts_ls.setup({
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = vue_language_server_path,
						languages = { "vue" },
					},
				},
			},
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
		})

		-- Configure Volar for Vue.js
		--	require("lspconfig").volar.setup({
		--		filetypes = { "vue" },
		--		on_attach = function(client, bufnr)
		--			-- Key mappings for LSP functions
		--			local function map(keys, func, desc)
		--				vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
		--			end

		--			map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
		--			map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
		--			map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
		--			map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		--			map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
		--		end,
		--	})

		-- Configure Tailwind CSS Language Server
		require("lspconfig").tailwindcss.setup({
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
		})
	end,
}
