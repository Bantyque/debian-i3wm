require("config.options")
require("config.keymaps")
require("config.lazy")

-- Меняем цвет текста диагностики (например, на светло-серый или другой, который тебе нравится)
-- Это сделает сообщения "неактивными" по цвету, чтобы они не отвлекали от кода
vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextWarn', { fg = '#888888', italic = true })
vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextInfo', { fg = '#888888', italic = true })
vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextHint', { fg = '#888888', italic = true })
vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', { fg = '#ff9999', bold = true }) -- Ошибки оставим заметными
