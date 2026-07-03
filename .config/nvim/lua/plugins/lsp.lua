return {
  {
    "neovim/nvim-lspconfig",
    event        = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Настройка поведения при подключении ЛЮБОГО сервера
      local on_attach = function(client, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end

        -- Твои горячие клавиши
        map("gd",          vim.lsp.buf.definition,     "Перейти к определению")
        map("gD",          vim.lsp.buf.declaration,    "Перейти к объявлению")
        map("gr",          vim.lsp.buf.references,     "Найти ссылки")
        map("K",           vim.lsp.buf.hover,          "Документация")
        map("<leader>ca",  vim.lsp.buf.code_action,    "Code Action")
        map("<leader>rn",  vim.lsp.buf.rename,         "Переименовать")

        -- МАГИЯ: Автоформатирование при сохранении силами запущенного LSP
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr, async = false })
            end,
          })
        end
      end

      -- Инициализация Mason
      require("mason").setup({ ui = { border = "rounded" } })

      -- Автоматическое подключение всего, что установлено в Mason
      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              on_attach    = on_attach,
            })
          end,
        },
      })

      -- Красивый вывод ошибок сбоку кода
      vim.diagnostic.config({
        virtual_text  = { prefix = "●", spacing = 4 },
        severity_sort = true,
        float         = { border = "rounded" },
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd    = "Mason",
    config = true,
  },
}
