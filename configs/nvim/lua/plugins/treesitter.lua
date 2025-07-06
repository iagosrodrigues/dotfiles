return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects"
    },
    config = function()
      local configs = require "nvim-treesitter.configs"

      configs.setup {
        sync_install = false,
        modules = {},
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true,
        ignore_install = {},
      }
    end,
  },
}
