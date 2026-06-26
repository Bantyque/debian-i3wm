return {
  {
    "dylanaraps/wal.vim",
    lazy     = false,
    priority = 1000,
    config   = function()
      vim.cmd("colorscheme wal")

      local function apply_wal_colors()
        local colors = {}
        local f = io.open(os.getenv("HOME") .. "/.cache/wal/colors-wal.vim", "r")
        if f then
          for line in f:lines() do
            local name, value = line:match("^let (color%d+)%s*=%s*\"(#%x+)\"")
            if name and value then colors[name] = value end
          end
          f:close()
        end
        local c = colors
        if not c.color1 then return end

        -- Фон — берём color0 из pywal но не полностью прозрачный
        local bg = c.color0 or "#1a1a1a"
        vim.api.nvim_set_hl(0, "Normal",      { bg = bg })
        vim.api.nvim_set_hl(0, "NormalNC",    { bg = bg })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg })
        vim.api.nvim_set_hl(0, "SignColumn",  { bg = bg })
        vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = bg })

        -- Подсветка синтаксиса (treesitter)
        vim.api.nvim_set_hl(0, "@keyword",             { fg = c.color3, bold = true })
        vim.api.nvim_set_hl(0, "@keyword.return",      { fg = c.color3, bold = true })
        vim.api.nvim_set_hl(0, "@keyword.function",    { fg = c.color3, bold = true })
        vim.api.nvim_set_hl(0, "@function",            { fg = c.color4 })
        vim.api.nvim_set_hl(0, "@function.builtin",    { fg = c.color6 })
        vim.api.nvim_set_hl(0, "@function.call",       { fg = c.color4 })
        vim.api.nvim_set_hl(0, "@string",              { fg = c.color2 })
        vim.api.nvim_set_hl(0, "@number",              { fg = c.color3 })
        vim.api.nvim_set_hl(0, "@boolean",             { fg = c.color5 })
        vim.api.nvim_set_hl(0, "@comment",             { fg = c.color8, italic = true })
        vim.api.nvim_set_hl(0, "@variable",            { fg = c.color7 })
        vim.api.nvim_set_hl(0, "@type",                { fg = c.color5 })
        vim.api.nvim_set_hl(0, "@constant",            { fg = c.color3 })
        vim.api.nvim_set_hl(0, "@operator",            { fg = c.color6 })
        vim.api.nvim_set_hl(0, "@punctuation",         { fg = c.color7 })
        vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = c.color6 })
        vim.api.nvim_set_hl(0, "@parameter",           { fg = c.color7 })
        vim.api.nvim_set_hl(0, "@field",               { fg = c.color4 })
        vim.api.nvim_set_hl(0, "@namespace",           { fg = c.color5 })
        vim.api.nvim_set_hl(0, "@tag",                 { fg = c.color1 })

        -- Neo-tree цвета
        vim.api.nvim_set_hl(0, "NeoTreeFileName",      { fg = c.color7 })
        vim.api.nvim_set_hl(0, "NeoTreeDirectory",     { fg = c.color7, bold = true })
        vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = c.color7 })
        vim.api.nvim_set_hl(0, "Directory",            { fg = c.color7 })
        vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = c.color4 })
        vim.api.nvim_set_hl(0, "NeoTreeFileIcon",      { fg = c.color6 })
        vim.api.nvim_set_hl(0, "NeoTreeGitModified",   { fg = c.color3 })
        vim.api.nvim_set_hl(0, "NeoTreeGitAdded",      { fg = c.color2 })
        vim.api.nvim_set_hl(0, "NeoTreeGitDeleted",    { fg = c.color1 })
        vim.api.nvim_set_hl(0, "NeoTreeIndentMarker",  { fg = c.color8 })
        vim.api.nvim_set_hl(0, "NeoTreeExpander",      { fg = c.color6 })
        vim.api.nvim_set_hl(0, "NeoTreeRootName",      { fg = c.color5, bold = true })

        -- Иконки devicons
        local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
        if devicons_ok then
          local icons = devicons.get_icons()
          for _, icon in pairs(icons) do
            icon.color = c.color4
          end
          devicons.set_icon(icons)
        end
      end

      vim.defer_fn(apply_wal_colors, 100)
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        callback = function()
          vim.defer_fn(apply_wal_colors, 100)
        end,
      })
    end,
  },
}
