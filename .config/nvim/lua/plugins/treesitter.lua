return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    main  = "nvim-treesitter",
    opts  = {
      ensure_installed = {
        "lua", "python", "bash",
        "vim", "vimdoc", "toml",
        "yaml", "json", "markdown",
      },
      auto_install = true,
      highlight    = { enable = true },
      indent       = { enable = true },
    },
  },
}
