require 'settings'
require 'plugins'
require 'keymappings'

require'kanagawa'.setup({
  dimInactive = true
})
vim.cmd 'set guifont=Berkeley_Mono,codicon,FiraCode_NF:h12'
vim.cmd "colorscheme kanagawa"

require("colors").overrides()

