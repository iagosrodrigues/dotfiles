require("mason").setup {
  ensure_installed = {},
}

require("mason-lspconfig").setup {
  ensure_installed = { "lua_ls", "vtsls", "rust_analyzer", "gopls", "templ", "zls", "clangd", "pyright" },
}
