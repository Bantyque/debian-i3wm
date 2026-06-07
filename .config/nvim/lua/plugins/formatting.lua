return {

  -- ── Conform (форматтер) ───────────────────────────────────────
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "black", "isort" },  -- black + isort для Python
          lua    = { "stylua" },
          sh     = { "shfmt" },
          bash   = { "shfmt" },
        },
        -- Форматировать при сохранении
        format_on_save = {
          timeout_ms   = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  -- ── Nvim-lint (линтер) ────────────────────────────────────────
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        python = { "flake8" },  -- flake8 для Python
        sh     = { "shellcheck" },
        bash   = { "shellcheck" },
      }
      -- Запускать линтер при сохранении и открытии
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

}
