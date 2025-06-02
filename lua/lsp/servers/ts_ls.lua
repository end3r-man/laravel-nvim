local volar_path = vim.fn.expand("$MASON/packages/vue-language-server/node_modules/@vue/language-server")

return {
	init_options = {
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = volar_path,
				languages = { "vue" },
			},
		},
	},
	settings = {
		typescript = {
			tsserver = { useSyntaxServer = false },
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
	},
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
}
