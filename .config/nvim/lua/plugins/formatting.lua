return {
  -- ── Conform (Динамический форматтер) ───────────────────────────
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          -- Для Python: проверяем по очереди, что установлено в Mason
          python = function()
            if vim.fn.executable("ruff") == 1 then
              return { "ruff_format" }
            elseif vim.fn.executable("black") == 1 then
              return { "black" }
            elseif vim.fn.executable("autopep8") == 1 then
              return { "autopep8" }
            else
              return {} -- Если ничего не установлено, форматирования не будет
            end
          end,

          -- Для Lua: если есть stylua — используем
          lua = function()
            if vim.fn.executable("stylua") == 1 then
              return { "stylua" }
            else
              return {}
            end
          end,

          -- Для Shell-скриптов
          sh = function()
            if vim.fn.executable("shfmt") == 1 then
              return { "shfmt" }
            else
              return {}
            end
          end,
          bash = function()
            if vim.fn.executable("shfmt") == 1 then
              return { "shfmt" }
            else
              return {}
            end
          end,
        },
        format_on_save = {
          timeout_ms   = 500,
          lsp_fallback = true, -- Если форматтера нет, попробует форматировать силами LSP (например, pylsp)
        },
      })
    end,
  },

  -- ── Nvim-lint (Динамический линтер) ────────────────────────────
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Умная функция: проверяет список кандидатов и оставляет только установленные
      local function get_active_linters(possible_linters)
        local active = {}
        for _, linter in ipairs(possible_linters) do
          if vim.fn.executable(linter) == 1 then
            table.insert(active, linter)
          end
        end
        return active
      end

      -- Карта потенциальных линтеров для твоих языков
      local linter_map = {
        python = { "ruff", "flake8", "pylint" },
        sh     = { "shellcheck" },
        bash   = { "shellcheck" },
      }

      -- Автокоманда динамически проверяет установленные линтеры при открытии/сохранении
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        callback = function()
          local ft = vim.bo.filetype
          if linter_map[ft] then
            -- Записываем в nvim-lint только то, что реально установлено прямо сейчас
            lint.linters_by_ft[ft] = get_active_linters(linter_map[ft])
          end
          lint.try_lint()
        end,
      })
    end,
  },
}
