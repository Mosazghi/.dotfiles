return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        markdownlint = {
          args = { "--disable", "MD013", "MD041", "--" },
        },
      },
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
      },
    },
  },
}
