return {
	cmd = { "intelephense", "--stdio" },
	root_markers = { "composer.json", ".git" },
	filetypes = { "php", "blade" },
	settings = {
		intelephense = {
			files = {
				maxSize = 5000000,
				associations = { "*.php", "*.blade.php" },
			},
			completion = {
				insertUseDeclaration = true,
				fullyQualifyGlobalConstantsAndFunctions = false,
			},
			diagnostics = {
				enable = true,
			},
			format = {
				enable = false, -- Use pint/php-cs-fixer via conform
			},
		},
	},
}
