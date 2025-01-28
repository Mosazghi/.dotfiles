vim.g.editorconfig = false
local opt = vim.opt
vim.opt.textwidth = 100
opt.backup = false
opt.cmdheight = 0
opt.confirm = true
vim.g.wrapmargin = 0
opt.expandtab = true
-- opt.fillchars:append({ eob = " " })
-- opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.laststatus = 3
opt.mouse = "a"
opt.number = true
opt.pumheight = 10
opt.relativenumber = true
opt.scrolloff = 8
opt.shiftwidth = 4
opt.showcmd = true
opt.showcmdloc = "statusline"
opt.showmode = false
opt.showtabline = 1
opt.smartcase = true
opt.smartindent = true
opt.spell = false
opt.spelllang = "en_us"
opt.swapfile = false
opt.tabstop = 4
opt.undofile = true
opt.undolevels = 10000

vim.g.snacks_animate = false
vim.opt.list = true
vim.opt.listchars = {
  lead = "·",
  trail = "•",
  multispace = "∅",
  nbsp = "‡",
  tab = "⇥»",
  precedes = "❮",
  extends = "❯",
  -- eol = "↵",
}
