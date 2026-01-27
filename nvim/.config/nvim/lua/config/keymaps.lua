local set = vim.keymap.set

set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })

set("n", "<M-,>", "<c-w>5<")
set("n", "<M-.>", "<c-w>5>")
set("n", "<M-t>", "<C-W>+")
set("n", "<M-s>", "<C-W>-")

set("", "<leader>cg", ":CMakeGenerate<cr>", {})
set("", "<leader>cb", ":CMakeBuild<cr>", {})
set("", "<leader>cqr", ":CMakeCloseRunner<cr>", {})
set("", "<leader>cqe", ":CMakeCloseExecutor<cr>", {})
set("", "<leader>cc", ":CMakeClean<cr>", {})
set("", "<leader>cx", ":CMakeRun<cr>", {})
set("", "<leader>e", ":Oil<cr>", {})
