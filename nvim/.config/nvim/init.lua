vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("config.lazy")
require("config.statusline")

require("lspconfig").clangd.setup({
  cmd = {
    "clangd",
    "--background-index",
    "--compile-commands-dir=build",
    "--header-insertion=never",
  },
}
)

vim.keymap.set("n", "<leader>å", function()
  local lang = vim.fn.input("Language: ")
  local lines = { "```" .. lang, "", "```" }
  vim.api.nvim_put(lines, "l", true, true)
  -- Move cursor to the empty line inside the code block
  vim.cmd("normal! k")
end, { desc = "Insert code block" })
