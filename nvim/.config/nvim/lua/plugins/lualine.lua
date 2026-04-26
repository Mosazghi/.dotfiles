-- 1. Put the function at the top of your lualine plugin file
local function overleaf_collaborators()
  local ok, ol = pcall(require, "overleaf")
  if not ok then
    return ""
  end

  -- If we are disconnected, show a red warning
  -- BEST FILTER: Only show on actual Overleaf buffers
  local bufnr = vim.api.nvim_get_current_buf()
  if not string.match(vim.api.nvim_buf_get_name(bufnr), "^overleaf://") then
    return "" -- Hide completely if we aren't in an Overleaf file
  end
  if not ol._state.connected then
    return "⛔ Disconnected"
  end

  local cursors = require("overleaf.cursors")
  local project = require("overleaf.project")
  local active_users = {}

  for _, collab in pairs(cursors._collaborators) do
    if collab.name then
      local initials = ""
      for word in collab.name:gmatch("%S+") do
        initials = initials .. word:sub(1, 1):upper()
      end

      if initials == "" then
        initials = "?"
      end

      if collab.doc_id then
        local doc = project.get_doc_by_id(collab.doc_id)
        if doc and doc.name then
          initials = initials .. " (" .. doc.name .. ")"
        end
      end
      table.insert(active_users, initials)
    end
  end

  if #active_users == 0 then
    return "🟢 Online" -- Let you know the connection is healthy even if no one else is there
  end

  return "👥 " .. table.concat(active_users, ", ")
end

local function overleaf_compile_status()
  local ok, ol = pcall(require, "overleaf")
  if not ok or not ol._state.connected then
    return ""
  end

  local bufnr = vim.api.nvim_get_current_buf()

  -- Only show this on actual overleaf files
  if vim.bo[bufnr].buftype ~= "acwrite" or not string.match(vim.api.nvim_buf_get_name(bufnr), "overleaf://") then
    return ""
  end

  -- Grab the specific namespace the plugin uses for LaTeX compile errors
  local ns = vim.api.nvim_create_namespace("overleaf_compile")

  -- Count how many errors exist in the current file
  local errors = vim.diagnostic.get(bufnr, {
    namespace = ns,
    severity = vim.diagnostic.severity.ERROR,
  })

  if #errors > 0 then
    return "❌ Compile Error (" .. #errors .. ")"
  else
    return ""
  end
end
-- 2. Inject it into your existing opts/setup block
return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts.sections = opts.sections or {}
    opts.sections.lualine_x = opts.sections.lualine_x or { "encoding", "fileformat", "filetype" }

    -- Insert the compile status first
    table.insert(opts.sections.lualine_x, 1, overleaf_compile_status)

    -- Insert the collaborators function next to it
    table.insert(opts.sections.lualine_x, 1, overleaf_collaborators)

    return opts
  end,
}
