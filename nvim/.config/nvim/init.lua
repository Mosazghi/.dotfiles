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
})

vim.keymap.set("n", "<leader>å", function()
  local lang = vim.fn.input("Language: ")
  local lines = { "```" .. lang, "", "```" }
  vim.api.nvim_put(lines, "l", true, true)
  -- Move cursor to the empty line inside the code block
  vim.cmd("normal! k")
end, { desc = "Insert code block" })

-- Create an auto-compile timer
local overleaf_timer = nil

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  pattern = "*", -- You can restrict this to "*.tex" if you want
  callback = function(args)
    -- Only run this for overleaf buffers (they use the acwrite buftype)
    if vim.bo[args.buf].buftype == "acwrite" and string.match(vim.api.nvim_buf_get_name(args.buf), "overleaf://") then
      -- Cancel the previous timer if they are still typing/syncing
      if overleaf_timer then
        vim.fn.timer_stop(overleaf_timer)
      end

      -- Set a new timer to compile after 3 seconds of inactivity
      overleaf_timer = vim.fn.timer_start(3000, function()
        overleaf_timer = nil

        -- Make sure we are still connected to Overleaf before trying to compile
        local ol = require("overleaf")
        if ol._state and ol._state.connected then
          ol.compile()
        end
      end)
    end
  end,
})
