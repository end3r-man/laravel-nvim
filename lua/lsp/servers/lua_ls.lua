return {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { disable = { "missing-fields" } },
			workspace = {
				checkThirdParty = false,
				library = {
					"${3rd}/luv/library",
					unpack(vim.api.nvim_get_runtime_file("", true)),
				},
			},
			completion = { callSnippet = "Replace" },
			format = { enable = false },
		},
	},
}
