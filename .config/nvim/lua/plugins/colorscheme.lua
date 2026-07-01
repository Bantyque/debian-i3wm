return {
  {
    "uZer/pywal16.nvim",
    lazy     = false,
    priority = 1000,
    config   = function()
      vim.opt.termguicolors = true

      local pywal16 = require("pywal16")
      pywal16.setup()
      vim.cmd("colorscheme pywal16")

      -- Получаем 16 динамических цветов без чтения файлов с диска
      local core_ok, core = pcall(require, "pywal16.core")
      if not core_ok then return end
      local c = core.get_colors()

      if not c or not c.color1 then return end

      -- Базовые группы и фоны (Логика из палитры "Banty" v2)
      local bg = c.color0
      vim.api.nvim_set_hl(0, "Normal",         { fg = c.color15, bg = bg })
      vim.api.nvim_set_hl(0, "NormalNC",       { fg = c.color7,  bg = bg })
      vim.api.nvim_set_hl(0, "NormalFloat",    { fg = c.color15, bg = bg })
      vim.api.nvim_set_hl(0, "SignColumn",     { bg = bg })
      vim.api.nvim_set_hl(0, "EndOfBuffer",    { fg = c.color8,  bg = bg })
      vim.api.nvim_set_hl(0, "Visual",         { bg = c.color8 })
      vim.api.nvim_set_hl(0, "CursorLine",     { bg = c.color0 })
      vim.api.nvim_set_hl(0, "CursorLineNr",   { fg = c.color3,  bg = bg })
      vim.api.nvim_set_hl(0, "LineNr",         { fg = c.color8,  bg = bg })
      vim.api.nvim_set_hl(0, "WinSeparator",    { fg = c.color8 })
      vim.api.nvim_set_hl(0, "FloatBorder",     { fg = c.color6 })

      -- Treesitter (Развернутая палитра по мотивам tender.vim)
      vim.api.nvim_set_hl(0, "@keyword",              { fg = c.color6,  bold = true })
      vim.api.nvim_set_hl(0, "@keyword.return",       { fg = c.color6,  bold = true })
      vim.api.nvim_set_hl(0, "@keyword.function",     { fg = c.color6,  bold = true })
      vim.api.nvim_set_hl(0, "@conditional",          { fg = c.color6 })
      vim.api.nvim_set_hl(0, "@repeat",               { fg = c.color6 })
      vim.api.nvim_set_hl(0, "@include",              { fg = c.color6 })
      vim.api.nvim_set_hl(0, "@exception",            { fg = c.color1,  bold = true })
      vim.api.nvim_set_hl(0, "@function",             { fg = c.color2 })
      vim.api.nvim_set_hl(0, "@function.builtin",     { fg = c.color14 })
      vim.api.nvim_set_hl(0, "@function.call",        { fg = c.color2 })
      vim.api.nvim_set_hl(0, "@method",               { fg = c.color2 })
      vim.api.nvim_set_hl(0, "@method.call",          { fg = c.color2 })
      vim.api.nvim_set_hl(0, "@string",               { fg = c.color3 })
      vim.api.nvim_set_hl(0, "@string.escape",        { fg = c.color9 })
      vim.api.nvim_set_hl(0, "@number",               { fg = c.color11 })
      vim.api.nvim_set_hl(0, "@float",                { fg = c.color11 })
      vim.api.nvim_set_hl(0, "@boolean",              { fg = c.color5 })
      vim.api.nvim_set_hl(0, "@comment",              { fg = c.color8,  italic = true })
      vim.api.nvim_set_hl(0, "@variable",             { fg = c.color15 })
      vim.api.nvim_set_hl(0, "@variable.builtin",     { fg = c.color13 })
      vim.api.nvim_set_hl(0, "@type",                 { fg = c.color4 })
      vim.api.nvim_set_hl(0, "@type.builtin",         { fg = c.color12 })
      vim.api.nvim_set_hl(0, "@constant",             { fg = c.color11 })
      vim.api.nvim_set_hl(0, "@constant.builtin",     { fg = c.color13 })
      vim.api.nvim_set_hl(0, "@operator",             { fg = c.color1 })
      vim.api.nvim_set_hl(0, "@punctuation",          { fg = c.color7 })
      vim.api.nvim_set_hl(0, "@punctuation.bracket",  { fg = c.color7 })
      vim.api.nvim_set_hl(0, "@punctuation.delimiter",{ fg = c.color8 })
      vim.api.nvim_set_hl(0, "@parameter",            { fg = c.color9 })
      vim.api.nvim_set_hl(0, "@field",                { fg = c.color4 })
      vim.api.nvim_set_hl(0, "@property",             { fg = c.color4 })
      vim.api.nvim_set_hl(0, "@namespace",            { fg = c.color13 })
      vim.api.nvim_set_hl(0, "@tag",                  { fg = c.color1 })
      vim.api.nvim_set_hl(0, "@tag.attribute",        { fg = c.color9 })
      vim.api.nvim_set_hl(0, "@attribute",            { fg = c.color11 })

      -- LSP диагностика
      vim.api.nvim_set_hl(0, "DiagnosticError",  { fg = c.color1 })
      vim.api.nvim_set_hl(0, "DiagnosticWarn",   { fg = c.color3 })
      vim.api.nvim_set_hl(0, "DiagnosticInfo",   { fg = c.color4 })
      vim.api.nvim_set_hl(0, "DiagnosticHint",   { fg = c.color6 })

      -- Neo-tree
      vim.api.nvim_set_hl(0, "NeoTreeFileName",      { fg = c.color7 })
      vim.api.nvim_set_hl(0, "NeoTreeDirectory",     { fg = c.color12, bold = true })
      vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = c.color12 })
      vim.api.nvim_set_hl(0, "Directory",            { fg = c.color6 })
      vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = c.color6 })
      vim.api.nvim_set_hl(0, "NeoTreeFileIcon",      { fg = c.color2 })
      vim.api.nvim_set_hl(0, "NeoTreeGitModified",   { fg = c.color3 })
      vim.api.nvim_set_hl(0, "NeoTreeGitAdded",      { fg = c.color10 })
      vim.api.nvim_set_hl(0, "NeoTreeGitDeleted",    { fg = c.color1 })
      vim.api.nvim_set_hl(0, "NeoTreeIndentMarker",  { fg = c.color8 })
      vim.api.nvim_set_hl(0, "NeoTreeExpander",      { fg = c.color8 })
      vim.api.nvim_set_hl(0, "NeoTreeRootName",      { fg = c.color13, bold = true })

      -- Devicons
      local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
      if devicons_ok then
        local icons = devicons.get_icons()
        for _, icon in pairs(icons) do
          icon.color = c.color2
        end
        devicons.set_icon(icons)
      end
    end,
  },
}
