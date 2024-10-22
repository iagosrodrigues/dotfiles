return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    keys = {
      {
        "<leader>fm",
        function()
          require("conform").format { async = true, lsp_fallback = true }
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = require "configs.conform",
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require "configs.mason"
    end,
  },
  { "williamboman/mason-lspconfig.nvim" },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },

  { "Bilal2453/luvit-meta", lazy = true },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require "nvim-treesitter.configs"

      configs.setup {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true,
        ignore_install = {},
        modules = {},
      }
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  {
    "stevearc/oil.nvim",
    opts = {},
    keys = {
      { "<leader>fe", "<cmd>Oil<CR>", "Open directory in buffer" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "mbbill/undotree",
  },
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      require("mini.pairs").setup()
      require("mini.ai").setup() -- Include the 'q' motion for quotes
    end,
  },
  {
    "j-hui/fidget.nvim",
    opts = {},
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = require("configs.lualine").init,
    opts = require("configs.lualine").opts,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = require("configs.noice").opts,
    keys = {
      { "<leader>sn", "", desc = "+noice" },
      {
        "<S-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect Cmdline",
      },
      {
        "<leader>snl",
        function()
          require("noice").cmd "last"
        end,
        desc = "Noice Last Message",
      },
      {
        "<leader>snh",
        function()
          require("noice").cmd "history"
        end,
        desc = "Noice History",
      },
      {
        "<leader>sna",
        function()
          require("noice").cmd "all"
        end,
        desc = "Noice All",
      },
      {
        "<leader>snd",
        function()
          require("noice").cmd "dismiss"
        end,
        desc = "Dismiss All",
      },
      {
        "<leader>snt",
        function()
          require("noice").cmd "pick"
        end,
        desc = "Noice Picker (Telescope/FzfLua)",
      },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Forward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Backward",
        mode = { "i", "n", "s" },
      },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd [[messages clear]]
      end
      require("noice").setup(opts)
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    opts = require("configs.nvim-cmp").opts,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
    },
  },
  -- {
  --   "navarasu/onedark.nvim",
  --   config = function()
  --     require("onedark").setup {
  --       style = "darker",
  --     }
  --     require("onedark").load()
  --   end,
  -- },
  -- {
  --   "p00f/alabaster.nvim",
  --   config = function()
  --     -- vim.cmd "colorscheme alabaster"
  --   end,
  -- },
  {
    "andreasvc/vim-256noir",
    config = function()
      -- vim.cmd "colorscheme 256_noir"
    end,
  },
  {
    "huyvohcmc/atlas.vim",
    config = function()
      -- vim.cmd "colorscheme atlas"
    end,
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require "notify"
      notify.setup {
        background_colour = "#000000",
      }
      vim.notify = notify
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require "configs.telescope"
    end,
  },
}
