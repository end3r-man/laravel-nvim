return {
	cmd = { "tailwindcss-language-server", "--stdio" },
	root_markers = {
		"tailwind.config.js",
		"tailwind.config.ts",
		"tailwind.config.cjs",
		"postcss.config.js",
		"postcss.config.ts",
		"package.json",
	},
	filetypes = {
		"html",
		"blade",
		"css",
		"scss",
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
			experimental = {
				classRegex = {
					{ "class:\\s*?[\"'`]([^\"'`]*).*?[\"'`]", "[\"'`]([^\"'`]*).*?[\"'`]" },
					{ "className:\\s*?[\"'`]([^\"'`]*).*?[\"'`]", "[\"'`]([^\"'`]*).*?[\"'`]" },
				},
			},
			includeLanguages = {
				blade = "html",
			},
		},
	},
}
