return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        harper_ls = {
          mason = false,

          settings = {
            ["harper-ls"] = {
              linters = {
                spell_check = true,
                spelled_numbers = false,
                an_a = true,
                sentence_capitalization = false,
                unclosed_quotes = true,
                wrong_quotes = false,
                long_sentences = true,
                repeated_words = true,
                spaces = true,
                matcher = true,
              },
            },
          },
        },
      },
    },
  },
}
