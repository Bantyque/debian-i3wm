
return {
  {
    "dylanaraps/wal.vim",
    lazy     = false,
    priority = 1000,
    config   = function()
      vim.cmd("colorscheme wal")
      -- Читаем цвета pywal
local colors = {
  color1 = vim.g.color1 or "#AF857B",
  color2 = vim.g.color2 or "#D17785",
  color3 = vim.g.color3 or "#B39F9B",
  color4 = vim.g.color4 or "#CC9C94",
  color5 = vim.g.color5 or "#CAB7B4",
  color6 = vim.g.color6 or "#D1C0BF",
  color7 = vim.g.color7 or "#c5c1c1",
}

-- Применяем к treesitter группам
vim.api.nvim_set_hl(0, "@keyword",          { fg = colors.color1, bold = true })
vim.api.nvim_set_hl(0, "@keyword.return",   { fg = colors.color1, bold = true })
vim.api.nvim_set_hl(0, "@function",         { fg = colors.color4 })
vim.api.nvim_set_hl(0, "@function.builtin", { fg = colors.color6 })
vim.api.nvim_set_hl(0, "@string",           { fg = colors.color2 })
vim.api.nvim_set_hl(0, "@number",           { fg = colors.color3 })
vim.api.nvim_set_hl(0, "@comment",          { fg = colors.color8 or "#6d5959", italic = true })
vim.api.nvim_set_hl(0, "@variable",         { fg = colors.color7 })
vim.api.nvim_set_hl(0, "@type",             { fg = colors.color5 })
vim.api.nvim_set_hl(0, "@constant",         { fg = colors.color3 })
vim.api.nvim_set_hl(0, "@operator",         { fg = colors.color6 })
vim.api.nvim_set_hl(0, "@punctuation",      { fg = colors.color7 })
      -- Прозрачный фон (как остальная система)
      vim.api.nvim_set_hl(0, "Normal",       { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalNC",     { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat",  { bg = "NONE" })
      vim.api.nvim_set_hl(0, "SignColumn",   { bg = "NONE" })
      vim.api.nvim_set_hl(0, "EndOfBuffer",  { bg = "NONE" })
    end,
  },
}
