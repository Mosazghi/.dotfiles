vim.g.cmake_link_compile_commands = 1

return {
  { "cdelledonne/vim-cmake" },
  vim.keymap.set("n", "<leader>cb", "<cmd>CMakeBuild<cr>"),
  vim.keymap.set("n", "<leader>cg", "<cmd>CMakeGenerate<cr>"),
}
