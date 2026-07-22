return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        -- Applies hidden files tracking to general pickers
        hidden = true,
        sources = {
          files = {
            -- Explicitly enables hidden files for the file finder
            hidden = true,
          },
        },
      },
    },
  },
}
