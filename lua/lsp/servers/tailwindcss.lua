local util = require("lspconfig").util
return {
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = { "html", "blade", "css", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" },
	root_dir = util.root_pattern(
		"tailwind.config.js",
		"tailwind.config.ts",
		"postcss.config.js",
		"postcss.config.ts",
		"package.json",
		"node_modules"
	),
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
}
