local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    -- python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
    python = {},
    javascript = { "biome", "biome-organize-imports", stop_after_first = true },
    javascriptreact = { "biome", "biome-organize-imports", stop_after_first = true },
    json = { "biome", "biome-organize-imports", stop_after_first = true },
    typescript = { "biome", "biome-organize-imports", stop_after_first = true },
    typescriptreact = { "biome", "biome-organize-imports", stop_after_first = true },
    html = { "prettier", stop_after_first = true },
    xml = { "xmlformatter" },
    yaml = { "prettier", stop_after_first = true },
    css = { "biome", "biome-organize-imports" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
