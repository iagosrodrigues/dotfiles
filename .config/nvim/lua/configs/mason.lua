require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "lua_ls", "vtsls", "rust_analyzer", "gopls", "templ", "zls", "clangd" },
}
