return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "luckasRanarison/tailwind-tools.nvim", name = "tailwind-tools", build = ":UpdateRemotePlugins" },
		"roobert/tailwindcss-colorizer-cmp.nvim",
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_registry = require("mason-registry")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local servers = {
			html = { filetypes = { "html", "blade" } },
			cssls = {},
			tailwindcss = {
				filetypes = { "html", "blade", "javascript", "typescript", "vue", "javascriptreact", "typescriptreact" },
			},
			jsonls = {},
			yamlls = {},
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { disable = { "missing-fields" } },
						format = { enable = false },
					},
				},
			},
			volar = {
				init_options = {
					vue = { hybridMode = false },
				},
				settings = {
					typescript = {
						inlayHints = {
							enumMemberValues = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							parameterTypes = { enabled = true, suppressWhenArgumentMatchesName = true },
							variableTypes = { enabled = true },
						},
					},
				},
			},
			ts_ls = {
				init_options = {
					plugins = {
						{
							name = "@vue/typescript-plugin",
							location = mason_registry.get_package("vue-language-server"):get_install_path()
								.. "/node_modules/@vue/language-server",
							languages = { "vue" },
						},
					},
				},
				settings = {
					typescript = {
						tsserver = { useSyntaxServer = false },
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
			emmet_language_server = {
				filetypes = { "css", "eruby", "html", "less", "sass", "scss", "pug", "blade" },
				init_options = {
					includeLanguages = { "javascript", "typescript" },
					excludeLanguages = { "vue" },
					showAbbreviationSuggestions = true,
					showExpandedAbbreviation = "always",
					showSuggestionsAsSnippets = false,
				},
			},
			phpactor = {
				cmd = { "phpactor", "language-server" },
				init_options = {
					["language_server.diagnostics_on_update"] = false,
					["language_server.diagnostics_on_open"] = true,
					["language_server.diagnostics_on_save"] = true,
					["language_server_phpstan.enabled"] = false,
					["language_server_psalm.enabled"] = false,
				},
				settings = {
					phpactor = {
						completion = { enabled = true },
						indexing = { enabled = true },
						diagnostics = { enabled = true },
					},
				},
			},

			gopls = {
				settings = {
					gopls = {
						analyses = { unusedparams = true },
						staticcheck = true,
						gofumpt = true,
					},
				},
			},
		}

		-- Global function to set up LSP
		local function setup_lsp()
			require("mason-tool-installer").setup({ ensure_installed = vim.tbl_keys(servers) })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

						vim.api.nvim_set_keymap(
							"n",
							"gd",
							"<cmd>lua vim.lsp.buf.definition()<CR>",
							{ noremap = true, silent = true }
						)
						vim.api.nvim_set_keymap(
							"n",
							"gr",
							"<cmd>lua vim.lsp.buf.references()<CR>",
							{ noremap = true, silent = true }
						)
						vim.api.nvim_set_keymap(
							"n",
							"K",
							"<cmd>lua vim.lsp.buf.hover()<CR>",
							{ noremap = true, silent = true }
						)

						lspconfig[server_name].setup(server)
					end,
				},
			})
		end

		-- Call the setup function to initialize LSP
		setup_lsp()
	end,
}
