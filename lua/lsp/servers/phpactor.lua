return {
	cmd = { "phpactor", "language-server" },
	root_markers = { "composer.json", ".git" },
	filetypes = { "php", "blade" },
	init_options = {
		["language_server.diagnostics_on_update"] = false,
		["language_server.diagnostics_on_open"] = true,
		["language_server.diagnostics_on_save"] = true,
		["language_server_phpstan.enabled"] = false,
		["language_server_psalm.enabled"] = false,
	},
}
