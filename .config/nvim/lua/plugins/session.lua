return {
  {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      require("auto-session").setup({
        auto_save_enabled    = true,
        auto_restore_enabled = true,
        auto_session_suppress_dirs = { "~/", "/tmp" },
      })
    end,
  },
}
