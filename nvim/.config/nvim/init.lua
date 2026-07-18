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
require("neotest").setup({
  adapters = {
    require("neotest").setup({
      is_test_file = function(file_path)
        return vim.endswith(file_path, "_test.cpp")
          or vim.endswith(file_path, "Test.cpp")
          or vim.startswith(file_path, "test_")
      end,
      get_test_directories = function()
        return { "build", "out", "build/tests" }
      end,
    }),
  },
})

vim.keymap.set("n", "<leader>å", function()
  local lang = vim.fn.input("Language: ")
  local lines = { "```" .. lang, "", "```" }
  vim.api.nvim_put(lines, "l", true, true)
  -- Move cursor to the empty line inside the code block
  vim.cmd("normal! k")
end, { desc = "Insert code block" })

-- -- Create an auto-compile timer
-- local overleaf_timer = nil
--
-- vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
--   pattern = "*", -- You can restrict this to "*.tex" if you want
--   callback = function(args)
--     -- Only run this for overleaf buffers (they use the acwrite buftype)
--     if vim.bo[args.buf].buftype == "acwrite" and string.match(vim.api.nvim_buf_get_name(args.buf), "overleaf://") then
--       -- Cancel the previous timer if they are still typing/syncing
--       if overleaf_timer then
--         vim.fn.timer_stop(overleaf_timer)
--       end
--
--       -- Set a new timer to compile after 3 seconds of inactivity
--       overleaf_timer = vim.fn.timer_start(3000, function()
--         overleaf_timer = nil
--
--         -- Make sure we are still connected to Overleaf before trying to compile
--         local ol = require("overleaf")
--         if ol._state and ol._state.connected then
--           ol.compile()
--           ol.refresh_comments()
--         end
--       end)
--     end
--   end,
-- })
--
-- vim.api.nvim_create_user_command("OverleafDownloadPDF", function()
--
--   local ok, ol = pcall(require, "overleaf")
--   if not ok or not ol._state.connected then
--     vim.notify("Overleaf not connected. Run :Overleaf first.", vim.log.levels.ERROR)
--     return
--   end
--
--   local config = require("overleaf.config")
--   local bridge = require("overleaf.bridge")
--
--   vim.notify("Compiling and downloading PDF...", vim.log.levels.INFO)
--
--   -- 1. Trigger a compile to get the freshest PDF URL
--   bridge.request("compile", {
--     cookie = config.get().cookie,
--     csrfToken = ol._state.csrf_token,
--     projectId = ol._state.project_id,
--   }, function(err, result)
--     if err then
--       vim.schedule(function()
--         vim.notify("Compile failed: " .. err.message, vim.log.levels.ERROR)
--       end)
--       return
--     end
--
--     -- 2. Find the output.pdf in the compilation results
--     local pdf_file = nil
--     for _, f in ipairs(result.outputFiles or {}) do
--       if f.path == "output.pdf" then
--         pdf_file = f
--         break
--       end
--     end
--
--     if not pdf_file or not pdf_file.url then
--       vim.schedule(function()
--         vim.notify("No PDF found in compile output.", vim.log.levels.WARN)
--       end)
--       return
--     end
--
--     -- 3. Download the PDF to the current working directory
--     local cwd = vim.fn.getcwd()
--     local filename = (ol._state.project_name or "output") .. ".pdf"
--
--     bridge.request("downloadUrl", {
--       cookie = config.get().cookie,
--       url = config.get().base_url .. pdf_file.url,
--       fileName = filename,
--       outputDir = cwd,
--     }, function(download_err, download_result)
--       if download_err then
--         vim.schedule(function()
--           vim.notify("Download failed: " .. download_err.message, vim.log.levels.ERROR)
--         end)
--         return
--       end
--
--       -- Success!
--       vim.schedule(function()
--         vim.notify("✅ Downloaded PDF to: " .. download_result.path, vim.log.levels.INFO)
--       end)
--     end)
--   end)
-- end, { desc = "Download Overleaf PDF to current directory" })
--
-- -- Optional: Map it to a shortcut like <leader>oD
-- vim.keymap.set("n", "<leader>oD", "<cmd>OverleafDownloadPDF<CR>", { desc = "Overleaf: Download PDF to CWD" })

local overseer = require("overseer")

overseer.register_template({
  name = "Zed Tasks",
  generator = function(opts, cb)
    local zed_path = vim.fs.joinpath(vim.fn.getcwd(), ".zed", "tasks.json")
    if vim.fn.filereadable(zed_path) == 0 then
      cb({})
      return
    end

    local file = io.open(zed_path, "r")
    if not file then
      cb({})
      return
    end
    local content = file:read("*a")
    file:close()

    local success, tasks = pcall(vim.json.decode, content)
    if not success or type(tasks) ~= "table" then
      cb({})
      return
    end

    local templates = {}
    for _, task in ipairs(tasks) do
      if task.label and task.command then
        table.insert(templates, {
          name = task.label,
          params = {},
          builder = function()
            -- Split the command string by spaces into an array
            local parts = vim.split(task.command, " ", { trimempty = true })
            local base_cmd = parts[1]

            -- Extract everything after the first word as arguments
            local args = {}
            for i = 2, #parts do
              local arg = parts[i]
              -- Handle the $(pwd) context macro used in your "Run assets" task
              if arg:find("%$%(pwd%)") then
                arg = arg:gsub("%$%(pwd%)", vim.fn.getcwd())
              end
              table.insert(args, arg)
            end

            return {
              cmd = base_cmd,
              args = args,
              name = task.label,
              components = { "default", "on_output_quickfix" },
            }
          end,
        })
      end
    end

    cb(templates)
  end,
})
