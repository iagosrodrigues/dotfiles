return {
  -- Firulas
  { "nvim-lua/plenary.nvim" },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      -- scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    }
  },
  -- {
  --   'tzachar/local-highlight.nvim',
  --   config = function()
  --     require('local-highlight').setup()
  --   end
  -- },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          auto_trigger = true
        }
      })
    end,
  },
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
    init = function(_)
      local pylsp = require("mason-registry").get_package("python-lsp-server")
      pylsp:on("install:success", function()
        local function mason_package_path(package)
          local path = vim.fn.resolve(vim.fn.stdpath("data") .. "/mason/packages/" .. package)
          return path
        end

        local path = mason_package_path("python-lsp-server")
        local command = path .. "/venv/bin/pip"
        local args = {
          "install",
          "-U",
          "pylsp-rope",
          "python-lsp-black",
          "python-lsp-isort",
          "python-lsp-ruff",
          "pyls-memestra",
          "pylsp-mypy",
        }

        require("plenary.job")
            :new({
              command = command,
              args = args,
              cwd = path,
            })
            :start()

        print("Installed python-lsp-server plugins")
      end)
    end
  },
  { "williamboman/mason-lspconfig.nvim" },
  {
    "jay-babu/mason-nvim-dap.nvim",
    config = function()
      require("mason-nvim-dap").setup({ ensure_installed = { "python" } })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  { "RRethy/vim-illuminate" },
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
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("configs.dap")
    end
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      require("dap-python").setup("python3")
    end
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        "nvim-dap-ui",
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
    config = function()
      local fidget = require "fidget"

      -- vim.notify = fidget.notify
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = require("configs.lualine").init,
    opts = require("configs.lualine").opts,
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
    config = function()
      require "configs.gitsigns"
    end,
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
  -- {
  --     "rcarriga/nvim-notify",
  --     config = function()
  --         local notify = require "notify"
  --         notify.setup {
  --             background_colour = "#000000",
  --         }
  --         vim.notify = notify
  --     end,
  -- },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    config = function()
      require "configs.telescope"
    end,
  },

  { "rose-pine/neovim",                           name = "rose-pine" },

  {
    "rbong/vim-flog",
    lazy = true,
    cmd = { "Flog", "Flogsplit", "Floggit" },
    dependencies = {
      "tpope/vim-fugitive",
    },
  },
  -- {
  --   "github/copilot.vim",
  --   config = function()
  --     vim.g.copilot_no_tab_map = true
  --
  --     vim.keymap.set(
  --       "i",
  --       "<c-y>",
  --       'copilot#Accept("\\<CR>")',
  --       { expr = true, replace_keycodes = false, desc = "Accept Copilot suggestion" }
  --     )
  --   end,
  -- },
  --
}
