require("core.options")
require("core.keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

	-- Lazy Config
	require("config.nvim_cmp"),
	require("config.nvim_conform"),
	require("config.nvim_laravel"),
	require("config.nvim_tailwind"),
	require("config.nvim_utility"),
	require("config.nvim_treesitter"),
	require("config.nvim_laravel"),
	require("config.nvim_precognition"),
	require("config.nvim_neoscroll"),
	require("config.nvim_comment"),

	--LSP Config
	require("lsp.init"),
	--require("lsp.vue"),

	-- UI Config
	require("ui.alpha"),
	require("ui.bufferline"),
	require("ui.differ"),
	require("ui.gitsigns"),
	require("ui.indent-blankline"),
	require("ui.lualine"),
	require("ui.neotree"),
	require("ui.telescope"),
	require("ui.theme"),
}, {
	performance = {
		rtp = { reset = false }, -- important, so nvim-treesitter works
	},
})
