require 'core.options'
require 'core.keymaps'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

  --LSP Config
  require('plugins.lsp.config'),

  -- Language Config
  require('plugins.lang.laravel'),
  require('plugins.lang.treesitter'),

  -- Auto Config
  require('plugins.auto.autocompletion'),
  require('plugins.auto.autoformating'),
  require('plugins.auto.autoinstall'),

  -- UI Config
  require('plugins.ui.alpha'),
  require('plugins.ui.bufferline'),
  require('plugins.ui.gitsigns'),
  require('plugins.ui.indent-blankline'),
  require('plugins.ui.lualine'),
  require('plugins.ui.neotree'),
  require('plugins.ui.telescope'),
  require('plugins.ui.theme'),
})
