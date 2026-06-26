return {

  -- ── Telescope ────────────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    cmd          = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")
      telescope.setup({
        defaults = {
          prompt_prefix    = "  ",
          selection_caret  = " ",
          path_display     = { "truncate" },
          sorting_strategy = "ascending",
          layout_config    = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
            width = 0.87, height = 0.80,
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Esc>"] = actions.close,
            },
          },
          find_command = { "fdfind", "--type", "f", "--hidden", "--exclude", ".git" },
        },
      })
      telescope.load_extension("fzf")
    end,
  },

  -- ── Neo-tree ─────────────────────────────────────────────────
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd          = "Neotree",
    branch       = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        use_default_mappings = true,
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
        window = { width = 28 },
        filesystem = {
          filtered_items = {
            visible         = true,
            hide_dotfiles   = false,
            hide_gitignored = true,
          },
          follow_current_file = { enabled = true },
        },
      })
    end,
  },

  -- ── Lualine ──────────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    event        = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function wal_theme()
        local f = io.open(os.getenv("HOME") .. "/.cache/wal/colors.json", "r")
        if not f then return "auto" end
        local content = f:read("*a")
        f:close()
        local bg = content:match('"background"%s*:%s*"(#%x+)"') or "#1a1a1a"
        local fg = content:match('"foreground"%s*:%s*"(#%x+)"') or "#d8d8d8"
        local c1 = content:match('"color1"%s*:%s*"(#%x+)"') or "#cc6666"
        local c3 = content:match('"color3"%s*:%s*"(#%x+)"') or "#f0c674"
        local c4 = content:match('"color4"%s*:%s*"(#%x+)"') or "#81a2be"
        return {
          normal = {
            a = { bg = c4, fg = bg, gui = "bold" },
            b = { bg = bg, fg = fg },
            c = { bg = bg, fg = fg },
          },
          insert = {
            a = { bg = c3, fg = bg, gui = "bold" },
            b = { bg = bg, fg = fg },
            c = { bg = bg, fg = fg },
          },
          visual = {
            a = { bg = c1, fg = bg, gui = "bold" },
            b = { bg = bg, fg = fg },
            c = { bg = bg, fg = fg },
          },
          replace = {
            a = { bg = c1, fg = bg, gui = "bold" },
            b = { bg = bg, fg = fg },
            c = { bg = bg, fg = fg },
          },
          command = {
            a = { bg = c3, fg = bg, gui = "bold" },
            b = { bg = bg, fg = fg },
            c = { bg = bg, fg = fg },
          },
          inactive = {
            a = { bg = bg, fg = fg },
            b = { bg = bg, fg = fg },
            c = { bg = bg, fg = fg },
          },
        }
      end

      require("lualine").setup({
        options = {
          theme                = wal_theme(),
          globalstatus         = true,
          component_separators = { left = "", right = "" },
          section_separators   = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- ── Barbar (вкладки) ─────────────────────────────────────────
  {
    "romgrk/barbar.nvim",
    event        = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "lewis6991/gitsigns.nvim",
    },
    config = function()
      require("barbar").setup({
        animation  = true,
        auto_hide  = false,
        tabpages   = true,
        clickable  = true,
        icons = {
          buffer_index  = false,
          buffer_number = false,
          button        = "",
          diagnostics = {
            [vim.diagnostic.severity.ERROR] = { enabled = true },
            [vim.diagnostic.severity.WARN]  = { enabled = true },
          },
          gitsigns = {
            added   = { enabled = true, icon = "+" },
            changed = { enabled = true, icon = "~" },
            deleted = { enabled = true, icon = "-" },
          },
          filetype  = { enabled = true },
          separator = { left = "▎", right = "" },
          modified  = { button = "●" },
          pinned    = { button = "󰐃", filename = true },
        },
      })
    end,
  },

  -- ── Gitsigns ─────────────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    event  = { "BufReadPost", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "│" },
          change       = { text = "│" },
          delete       = { text = "󰍵" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
        },
      })
    end,
  },

  -- ── Aerial (дерево кода) ─────────────────────────────────────
  {
    "stevearc/aerial.nvim",
    event        = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("aerial").setup({
        layout = {
          width             = 30,
          default_direction = "right",
        },
        show_guides = true,
        attach_mode = "global",
      })
    end,
  },

  -- ── Smear cursor (анимация курсора) ──────────────────────────
  {
    "sphamba/smear-cursor.nvim",
    event  = "VeryLazy",
    config = function()
      require("smear_cursor").setup({
        stiffness               = 0.8,
        trailing_stiffness      = 0.5,
        distance_stop_animating = 0.5,
        hide_target_hack        = false,
      })
    end,
  },

  -- ── Alpha (стартовое меню) ───────────────────────────────────
  {
    "goolord/alpha-nvim",
    event        = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dash  = require("alpha.themes.dashboard")

    dash.section.header.val = {
      "",
      "  ██████╗  █████╗ ███╗  ██╗████████╗██╗   ██╗  ",
      "  ██╔══██╗██╔══██╗████╗ ██║╚══██╔══╝╚██╗ ██╔╝  ",
      "  ██████╔╝███████║██╔██╗██║   ██║    ╚████╔╝   ",
      "  ██╔══██╗██╔══██║██║╚████║   ██║     ╚██╔╝    ",
      "  ██████╔╝██║  ██║██║ ╚███║   ██║      ██║     ",
      "  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚══╝   ╚═╝      ╚═╝     ",
      "",
    }
      dash.section.buttons.val = {
        dash.button("n", "  Новый файл",        "<cmd>enew<CR>"),
        dash.button("r", "  Недавние файлы",    "<cmd>Telescope oldfiles<CR>"),
        dash.button("f", "  Найти файл",        "<cmd>Telescope find_files<CR>"),
        dash.button("g", "  Поиск в файлах",    "<cmd>Telescope live_grep<CR>"),
        dash.button("c", "  Конфиг nvim",       "<cmd>edit ~/.config/nvim/init.lua<CR>"),
        dash.button("l", "  Менеджер плагинов", "<cmd>Lazy<CR>"),
        dash.button("q", "  Выйти",             "<cmd>qa<CR>"),
      }

      dash.section.footer.val = "  Меньше плагинов — больше дела"
      alpha.setup(dash.config)
    end,
  },

  -- ── Minimap ──────────────────────────────────────────────────
  {
    "echasnovski/mini.map",
    version = false,
    event   = { "BufReadPost", "BufNewFile" },
    config  = function()
      local map = require("mini.map")
      map.setup()
      vim.keymap.set("n", "<leader>mm", map.toggle, { desc = "Minimap" })
    end,
  },

  -- ── Which-key (подсказки клавиш) ─────────────────────────────
  {
    "folke/which-key.nvim",
    event  = "VeryLazy",
    config = function()
      require("which-key").setup({ delay = 400 })
      require("which-key").add({
        { "<leader>f", group = "Поиск" },
        { "<leader>l", group = "LSP" },
        { "<leader>g", group = "Git" },
        { "<leader>s", group = "Окна" },
        { "<leader>b", group = "Буферы" },
        { "<leader>m", group = "Minimap" },
      })
    end,
  },

  -- ── Autopairs ────────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event  = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({ check_ts = true })
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- ── Comment ──────────────────────────────────────────────────
  {
    "numToStr/Comment.nvim",
    event  = { "BufReadPost", "BufNewFile" },
    config = true,
  },

  -- ── Nvim-web-devicons ────────────────────────────────────────
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- ── Indent lines ─────────────────────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    main  = "ibl",
    event = "BufReadPost",
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
        },
        scope = {
          enabled = true,
        },
      })
    end,
  },
}
