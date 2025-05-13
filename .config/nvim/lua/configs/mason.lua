require("mason").setup()

require("mason-lspconfig").setup {
  automatic_installation = true,
  ensure_installed = { "lua_ls", "vtsls", "rust_analyzer", "gopls", "templ", "zls", "clangd", "pylsp" },
}
