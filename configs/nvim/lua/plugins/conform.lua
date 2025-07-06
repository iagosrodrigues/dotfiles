return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format { async = true, lsp_fallback = true }
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  opts = {},
  config = function()
    require("conform").setup {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
        -- python = {},
        typescript = { "biome", "biome-check" },
        typescriptreact = { "biome", "biome-check" },
        javascript = { "biome", "biome-check" },
        javascriptreact = { "biome", "biome-check" },
        json = { "biome", "biome-check" },
        html = { "prettier", stop_after_first = true },
        xml = { "xmlformatter" },
        yaml = { "prettier", stop_after_first = true },
        css = { "biome", "biome-check" },
      },
    }
  end,
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
