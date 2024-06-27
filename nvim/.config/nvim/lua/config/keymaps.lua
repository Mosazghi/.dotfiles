local set = vim.keymap.set

set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })

set("n", "<M-,>", "<c-w>5<")
set("n", "<M-.>", "<c-w>5>")
set("n", "<M-t>", "<C-W>+")
set("n", "<M-s>", "<C-W>-")

set("", "<leader>cg", ":CMakeGenerate<cr>", {})
set("", "<leader>cb", ":CMakeBuild<cr>", {})
set("", "<leader>cq", ":CMakeClose<cr>", {})
set("", "<leader>cc", ":CMakeClean<cr>", {})
set("", "<leader>e", ":Oil<cr>", {})
