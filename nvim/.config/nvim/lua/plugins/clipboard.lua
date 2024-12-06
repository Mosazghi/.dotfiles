return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    filetypes = {
      markdown = {
        --<img src="Assets/icon.png" width="200">
        template = '<img src="$FILE_PATH" alt="$FILE_NAME_NO_EXT" width="400"/>',
      },
    },
  },
  keys = {
    -- suggested keymap
    { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
  },
}
