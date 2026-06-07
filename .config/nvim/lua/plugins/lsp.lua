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

      local on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end
        map("gd",          vim.lsp.buf.definition,     "Перейти к определению")
        map("gD",          vim.lsp.buf.declaration,    "Перейти к объявлению")
        map("gr",          vim.lsp.buf.references,     "Найти ссылки")
        map("K",           vim.lsp.buf.hover,          "Документация")
        map("<leader>ca",  vim.lsp.buf.code_action,    "Code Action")
        map("<leader>rn",  vim.lsp.buf.rename,         "Переименовать")
      end

      require("mason").setup({ ui = { border = "rounded" } })

      require("mason-lspconfig").setup({
        ensure_installed = { "pylsp" },  -- только Python
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              on_attach    = on_attach,
            })
          end,
        },
      })

      vim.diagnostic.config({
        virtual_text  = { prefix = "●" },
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
