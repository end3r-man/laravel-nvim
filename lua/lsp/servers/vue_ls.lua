return {
	filetypes = {
		"typescript",
		"javascript",
		"javascriptreact",
		"typescriptreact",
		"vue",
	},
	init_options = {
		vue = {
			-- disable hybrid mode
			hybridMode = true,
		},
		vetur = {
			completion = {
				autoImport = true,
				tagCasing = "kebab",
				useScaffoldSnippets = false,
			},
			format = {
				defaultFormatter = {
					html = "none",
					js = "none",
					ts = "none",
				},
				defaultFormatterOptions = {},
				scriptInitialIndent = false,
				styleInitialIndent = false,
			},
			useWorkspaceDependencies = false,
			validation = {
				script = true,
				style = true,
				template = true,
				templateProps = true,
				interpolation = true,
			},
			experimental = {
				templateInterpolationService = true,
			},
		},
	},
}
