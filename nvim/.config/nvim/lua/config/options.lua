vim.g.cmake_link_compile_commands = 1

vim.g.wrap = true
vim.g.textwidth = 80
vim.g.wrapmargin = 0
-- vim.g.linebreak = true

vim.opt.inccommand = "split"

vim.opt.scrolloff = 10
vim.opt.inccommand = "split"

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.cmdheight = 0
-- idk
local opt = vim.opt
local o = vim.o
local fn = vim.fn

-- General
-- opt.numberwidth = 1
-- opt.number = true
--
-- opt.confirm = true
-- opt.shortmess = "aoOstTWAIcCFSq"
-- opt.updatetime = 100
-- opt.splitkeep = "screen"

-- Window
-- opt.splitright = true
-- opt.splitbelow = true
-- opt.title = true

-- Movement
-- opt.whichwrap = o.whichwrap .. "<,>,h,l"

-- Status
-- opt.showmode = false
-- -- opt.mouse = "a"
-- opt.showcmd = false
-- opt.showtabline = 0

-- Indentation
-- opt.tabstop = 2
-- opt.softtabstop = 2
-- opt.shiftwidth = 2
-- opt.expandtab = true
-- opt.smartindent = true
-- opt.linebreak = true
-- opt.showbreak = string.rep(" ", 3)

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.wildoptions = "pum"

-- Editing
opt.modelines = 1
opt.breakindent = true
opt.showmatch = true
opt.swapfile = false
opt.undodir = fn.stdpath("data") .. "/undodir"
opt.undofile = true
-- opt.textwidth = 80
-- opt.wrap = true
-- opt.inccommand = "split"
-- opt.diffopt = {
--   "internal",
--   "filler",
--   "closeoff",
--   "hiddenoff",
--   "algorithm:minimal",
-- }
--
-- opt.pumblend = 12
-- opt.clipboard = "unnamedplus"
-- opt.formatoptions = opt.formatoptions
--   - "t" -- wrap with text width
--   + "c" -- wrap comments
--   - "r" -- insert comment after enter
--   - "o" -- insert comment after o/O
--   - "q" -- allow formatting of comments with gq
--   - "a" -- format paragraphs
--   + "n" -- recognized numbered lists
--   - "2" -- use indent of second line for paragraph
--   + "l" -- long lines are not broken
--   + "j" -- remove comment when joining lines
-- opt.syntax = "off"

-- Colors
opt.termguicolors = true
