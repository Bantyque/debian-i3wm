return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy  = false,
    config = function()
      -- Включаем определение filetype
      vim.cmd("filetype plugin indent on")

      vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function(args)
          -- Определяем filetype если не определён
          if vim.bo[args.buf].filetype == "" then
            vim.cmd("filetype detect")
          end
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
}
