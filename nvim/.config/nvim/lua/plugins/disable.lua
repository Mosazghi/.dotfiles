return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  {
    "echasnovski/mini.comment",
    enabled = false,
  },
  {
    "folke/noice.nvim",
    enabled = false,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
  {
    "nvim-pack/nvim-spectre",
    ebabled = false,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = false },
      zen = { enabled = false },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    enabled = false,
  },
  {
    "yioneko/nvim-vtsls",
    enabled = false,
  },
}
