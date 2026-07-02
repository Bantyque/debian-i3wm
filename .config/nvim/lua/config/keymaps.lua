-- ============================================================
--  Горячие клавиши
-- ============================================================
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- ── Основные ─────────────────────────────────────────────────
map("n", "<Esc>",     "<cmd>nohlsearch<CR>",  { desc = "Снять подсветку поиска" })
map("n", "<leader>w", "<cmd>w<CR>",           { desc = "Сохранить" })
map("n", "<leader>q", "<cmd>q<CR>",           { desc = "Закрыть" })
map("n", "<leader>Q", "<cmd>qa!<CR>",         { desc = "Закрыть всё" })
map("n", "<leader>x", "<cmd>wq<CR>",          { desc = "Сохранить и закрыть" })

-- ── Движение (с центрированием экрана) ───────────────────────
map("n", "<C-d>", "<C-d>zz", { desc = "Вниз + центр" })
map("n", "<C-u>", "<C-u>zz", { desc = "Вверх + центр" })
map("n", "n",     "nzzzv",   { desc = "Следующий результат + центр" })
map("n", "N",     "Nzzzv",   { desc = "Предыдущий результат + центр" })

-- ── Окна ─────────────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Окно влево" })
map("n", "<C-l>", "<C-w>l", { desc = "Окно вправо" })
map("n", "<C-j>", "<C-w>j", { desc = "Окно вниз" })
map("n", "<C-k>", "<C-w>k", { desc = "Окно вверх" })
map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Разделить вертикально" })
map("n", "<leader>sh", "<cmd>split<CR>",  { desc = "Разделить горизонтально" })

-- ── Буферы (barbar) ──────────────────────────────────────────
map("n", "<S-l>",      "<cmd>BufferNext<CR>",     { desc = "Следующий буфер" })
map("n", "<S-h>",      "<cmd>BufferPrevious<CR>", { desc = "Предыдущий буфер" })
map("n", "<leader>bd", "<cmd>BufferClose<CR>",    { desc = "Закрыть буфер" })
map("n", "<leader>bp", "<cmd>BufferPin<CR>",      { desc = "Закрепить буфер" })

-- ── Редактирование и буфер обмена ────────────────────────────
-- Копирование в системный буфер (работает и в обычном режиме, и в выделении)
map({"n", "v"}, "<leader>y", [["+y]], { desc = "Копировать в системный буфер" })
map("n",        "<leader>Y", [["+Y]], { desc = "Копировать строку в системный буфер" })

-- Вставка из системного буфера обмена
map({"n", "v"}, "<leader>p", [["+p]], { desc = "Вставить из системного буфера" })
map({"n", "v"}, "<leader>P", [["+P]], { desc = "Вставить из системного буфера (перед курсором)" })

-- Стандартные операции для визуального режима
map("v", "J", ":m '>+1<CR>gv=gv",  { desc = "Переместить строку вниз" })
map("v", "K", ":m '<-2<CR>gv=gv",  { desc = "Переместить строку вверх" })
map("v", "<", "<gv",                { desc = "Indent влево" })
map("v", ">", ">gv",                { desc = "Indent вправо" })

-- ── Telescope ────────────────────────────────────────────────
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>",          { desc = "Найти файл" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",           { desc = "Поиск в файлах" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",             { desc = "Буферы" })
map("n", "<leader>fh", "<cmd>Telescope find_files hidden=true<CR>", { desc = "Найти скрытые файлы" })
-- Вот ваш новый удобный биндинг на space+o (открывает недавние файлы)
map("n", "<leader>o",  "<cmd>Telescope oldfiles<CR>",            { desc = "Недавние файлы (Telescope)" })

-- ── Neo-tree ─────────────────────────────────────────────────
map("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Файловый менеджер" })

-- ── Aerial (дерево кода) ─────────────────────────────────────
map("n", "<leader>a", "<cmd>AerialToggle<CR>", { desc = "Дерево кода" })

-- ── LSP ──────────────────────────────────────────────────────
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Ошибка подробно" })
map("n", "]d",         vim.diagnostic.goto_next,  { desc = "Следующая ошибка" })
map("n", "[d",         vim.diagnostic.goto_prev,  { desc = "Предыдущая ошибка" })

-- ── Git ──────────────────────────────────────────────────────
map("n", "<leader>gh", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Предпросмотр изменения" })
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>",   { desc = "Git blame" })
map("n", "]g",         "<cmd>Gitsigns next_hunk<CR>",    { desc = "Следующее изменение" })
map("n", "[g",         "<cmd>Gitsigns prev_hunk<CR>",    { desc = "Предыдущее изменение" })

-- ── Форматирование ───────────────────────────────────────────
map("n", "<leader>lf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Форматировать файл" })

-- ── Терминал ─────────────────────────────────────────────────
map("n", "<leader>t", "<cmd>split | terminal<CR>", { desc = "Открыть терминал" })

-- ── Запуск файла F5 (Умный запуск в терминале) ───────────────
map("n", "<F5>", function()
  local ft = vim.bo.filetype
  if ft == "python" then
    vim.cmd("split | terminal python3 %")
  elseif ft == "sh" then
    vim.cmd("split | terminal bash %")
  elseif ft == "lua" then
    vim.cmd("split | terminal lua %")
  end
end, { desc = "Запустить файл" })

-- Переключение раскладки на английскую при выходе из Insert режима
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    os.execute("xkb-switch -s us 2>/dev/null")
  end,
})

-- Выпрыгнуть за закрывающую скобку/кавычку в insert mode через Ctrl+l
vim.keymap.set('i', '<C-l>', '<Right>', { desc = 'Jump past closing bracket' })
