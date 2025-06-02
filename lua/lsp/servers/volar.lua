return {
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
	-- If you want to use Take Over Mode, include the above filetypes
	init_options = {
		languageFeatures = {
			implementation = true,
			documentHighlight = true,
			documentLink = true,
			codeLens = { showReferencesNotification = true },
			semanticTokens = false,
			diagnostics = true,
			schemaRequestService = true,
		},
		documentFeatures = {
			selectionRange = true,
			foldingRange = true,
			linkedEditingRange = true,
			documentSymbol = true,
			documentColor = true,
			documentFormatting = {
				defaultPrintWidth = 100,
			},
		},
	},
}
