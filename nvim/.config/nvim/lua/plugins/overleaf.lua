return {
  "richwomanbtc/overleaf.nvim",
  config = function()
    require("overleaf").setup({
      -- 1. Save PDFs to a predictable folder rather than the system temp directory
      pdf_dir = vim.fn.expand("~/.local/state/nvim/overleaf_pdfs"),
      -- 2. Stop the plugin from launching a new window on every compile.
      -- 'true' acts as a silent no-op command on Linux/macOS.
      pdf_viewer = "true",
    })
  end,
  build = "cd node && npm install",
}
