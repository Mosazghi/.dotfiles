return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  opts = function(_, opts)
    local config = require("fzf-lua.config")
    config.defaults.keymap.fzf["ctrl-a"] = "select-all+accept"
  end,
}
