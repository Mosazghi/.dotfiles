vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("config.lazy")
require("config.statusline")

require("multicursors").setup({
  hint_config = false,
})
