return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local lsp_attach_group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true })
		local volar_install_path =
			vim.fn.expand("$MASON/packages/vue-language-server/node_modules/@vue/language-server")

		-- Keymaps on LSP attach
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
				map("K", vim.lsp.buf.hover, "Show hover documentation")
			end,
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		local servers = {
			html = { filetypes = { "html", "blade" } },
			cssls = {},
			tailwindcss = {
				cmd = { "tailwindcss-language-server", "--stdio" },
				root_dir = require("lspconfig").util.root_pattern(
					"tailwind.config.js",
					"tailwind.config.ts",
					"postcss.config.js",
					"postcss.config.ts",
					"package.json",
					"node_modules"
				),
				filetypes = {
					"html",
					"blade",
					"css",
					"javascript",
					"typescript",
					"javascriptreact",
					"typescriptreact",
					"vue",
				},
				settings = {
					tailwindCSS = {
						lint = {
							cssConflict = "warning",
							invalidApply = "error",
							invalidConfigPath = "error",
							invalidScreen = "error",
							invalidTailwindDirective = "error",
							invalidVariant = "error",
							recommendedVariantOrder = "warning",
						},
						validate = true,
					},
				},
				flags = { debounce_text_changes = 150 },
			},
			jsonls = {},
			yamlls = {},
			lua_ls = {
				settings = {
					Lua = {
						completion = { callSnippet = "Replace" },
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
				filetypes = { "vue" },
				init_options = {
					vue = {
						hybridMode = true,
					},
					typescript = {
						tsdk = vim.fn.expand(
							"~/.local/share/nvim/mason/packages/vue-language-server/node_modules/typescript/lib"
						),
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
			ts_ls = {
				init_options = {
					plugins = {
						{
							name = "@vue/typescript-plugin",
							location = volar_install_path,
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
			emmet_language_server = {
				filetypes = {
					"css",
					"eruby",
					"html",
					"less",
					"sass",
					"scss",
					"pug",
					"blade",
				},
				init_options = {
					includeLanguages = { "javascript", "typescript" },
					excludeLanguages = { "vue" },
					extensionsPath = {},
					preferences = {},
					showAbbreviationSuggestions = true,
					showExpandedAbbreviation = "always",
					showSuggestionsAsSnippets = false,
					syntaxProfiles = {},
					variables = {},
				},
			},
			phpactor = {
				init_options = {
					["language_server.diagnostics_on_update"] = false,
					["language_server.diagnostics_on_open"] = true,
					["language_server.diagnostics_on_save"] = true,
					["language_server_phpstan.enabled"] = true,
					["language_server_psalm.enabled"] = false,
				},
			},
			--	gopls = {
			--		settings = {
			--			gopls = {
			--				analyses = { unusedparams = true },
			--				staticcheck = true,
			--				gofumpt = true,
			--			},
			--		},
			--	},
		}

		local ensure_installed = vim.tbl_keys(servers)
		vim.list_extend(ensure_installed, { "stylua" })

		--require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}
