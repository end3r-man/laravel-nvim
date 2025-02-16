return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local lsp_attach_group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true })
		local mason_registry = require("mason-registry")
		local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
			.. "/node_modules/@vue/language-server"

		-- LSP Attach autocmd to map keys
		vim.api.nvim_create_autocmd("LspAttach", {
			group = lsp_attach_group,
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				local bufnr = event.buf

				local function map(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
				end

				map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
				map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
				map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
				map("K", vim.lsp.buf.hover, "Show hover documentation") -- Added for hover documentation
			end,
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		local servers = {
			html = { filetypes = { "html", "twig", "hbs", "blade" } },
			cssls = {},
			tailwindcss = {},
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
			volar = {
				init_options = {
					vue = {
						hybridMode = false,
					},
				},
				settings = {
					typescript = {
						inlayHints = {
							enumMemberValues = {
								enabled = true,
							},
							functionLikeReturnTypes = {
								enabled = true,
							},
							propertyDeclarationTypes = {
								enabled = true,
							},
							parameterTypes = {
								enabled = true,
								suppressWhenArgumentMatchesName = true,
							},
							variableTypes = {
								enabled = true,
							},
						},
					},
				},
			},
			-- TypeScript
			ts_ls = {
				init_options = {
					plugins = {
						{
							name = "@vue/typescript-plugin",
							location = vue_language_server_path,
							languages = { "vue" },
						},
					},
				},
				settings = {
					typescript = {
						tsserver = {
							useSyntaxServer = false,
						},
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = true,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayVariableTypeHintsWhenTypeMatchesName = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
				},
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			},
		}

		-- Ensure all servers are installed
		local ensure_installed = vim.tbl_keys(servers)
		vim.list_extend(ensure_installed, { "stylua" })
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		-- Set up mason-lspconfig with handlers
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})

		-- PHP Actor Configuration
		require("lspconfig").phpactor.setup({
			on_attach = function(client, bufnr)
				-- Additional PHP Actor-specific configurations can be added here
			end,
			init_options = {
				["language_server.diagnostics_on_update"] = false,
				["language_server.diagnostics_on_open"] = true,
				["language_server.diagnostics_on_save"] = true,
				["language_server_phpstan.enabled"] = true,
				["language_server_psalm.enabled"] = true,
			},
		})

		-- Emmet Language Server Configuration
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
				includeLanguages = { "javascript", "typescript", "vue" },
				excludeLanguages = {},
				extensionsPath = {},
				preferences = {},
				showAbbreviationSuggestions = true,
				showExpandedAbbreviation = "always",
				showSuggestionsAsSnippets = false,
				syntaxProfiles = {},
				variables = {},
			},
			capabilities = capabilities,
		})

		-- TypeScript Language Server Configuration (Vue integration)
		--	require("lspconfig").ts_ls.setup({
		--		init_options = {
		--			plugins = {
		--				{
		--					name = "@vue/typescript-plugin",
		--					location = vue_language_server_path,
		--					languages = { "vue" },
		--				},
		--			},
		--		},
		--		filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
		--	})
	end,
}
