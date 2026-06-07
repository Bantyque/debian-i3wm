-- ============================================================
--  Базовые настройки
-- ============================================================
local opt = vim.opt

-- Нумерация строк
opt.number         = true
opt.relativenumber = true

-- Внешний вид
opt.cursorline     = true
opt.signcolumn     = "yes"
opt.termguicolors  = true
opt.showmode       = false       -- режим показывает lualine
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.wrap           = false
opt.fillchars      = { eob = " " }  -- убрать ~ в конце буфера
opt.laststatus     = 3              -- глобальный статусбар

-- Табуляция
opt.tabstop        = 4
opt.shiftwidth     = 4
opt.expandtab      = true
opt.smartindent    = true

-- Поиск
opt.ignorecase     = true
opt.smartcase      = true
opt.hlsearch       = true
opt.incsearch      = true

-- Файлы
opt.encoding       = "utf-8"
opt.fileencoding   = "utf-8"
opt.swapfile       = false
opt.backup         = false
opt.undofile       = true
opt.undodir        = vim.fn.stdpath("data") .. "/undo"

-- Производительность
opt.updatetime     = 250
opt.timeoutlen     = 400

-- Разное
opt.splitbelow     = true
opt.splitright     = true
opt.mouse          = "a"
opt.clipboard      = "unnamedplus"
opt.completeopt    = "menu,menuone,noselect"
opt.pumheight      = 10
