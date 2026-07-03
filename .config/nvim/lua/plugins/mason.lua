return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Открыть Mason" } },
  opts = {
    ui = { border = "rounded" },
  },
  config = function(_, opts)
    require("mason").setup(opts) -- Просто включаем графическую оболочку
  end,
}
