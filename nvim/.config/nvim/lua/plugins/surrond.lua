return {
  "kylechui/nvim-surround",
  version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
  config = function()
    require("nvim-surround").setup({
      surrounds = {
        -- Custom 'I' key for identical arbitrary length surrounds
        ["I"] = {
          add = function()
            local config = require("nvim-surround.config")
            -- Prompt the user once for any string
            local result = config.get_input("Enter surround string: ")
            if result then
              -- Return it as both the left and right surround
              return { { result }, { result } }
            end
            return nil
          end,
        },
      },
    })
  end,
}
