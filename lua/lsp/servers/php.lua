return {
	init_options = {
		["language_server.diagnostics_on_update"] = false,
		["language_server.diagnostics_on_open"] = true,
		["language_server.diagnostics_on_save"] = true,
		["language_server_phpstan.enabled"] = true,
		["language_server_psalm.enabled"] = false,
	},
	filetypes = { "php" },
	root_pattern = { "composer.json", ".git" },
}
