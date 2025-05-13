local M = {}

local map = vim.keymap.set
local lspconfig = require "lspconfig"

M.on_attach = function(client, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  if client then
    if client.supports_method("textDocument/rename") then
      map("n", "<leader>cd", vim.lsp.buf.rename, opts "Rename")
    end
    if client.supports_method("textDocument/implementation") then
      map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
    end
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")

  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")

  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
  map("n", "gr", vim.lsp.buf.references, opts "Show references")
end

M.on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

local servers = { "lua_ls", "vtsls", "tailwindcss", "gopls", "zls", "clangd", "yamlls", "html", "rust_analyzer" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
  }
end

lspconfig.pylsp.setup {
  on_attach = M.on_attach,
  on_init = M.on_init,
  capabilities = M.capabilities,
}

-- lspconfig.ruff.setup {
--   on_attach = M.on_attach,
--   on_init = M.on_init,
--   capabilities = M.capabilities,
--   init_options = {
--     settings = {
--       fixAll = true,
--       organizeImports = true,
--     },
--   },
-- }

-- lspconfig.pyright.setup {
--   on_attach = M.on_attach,
--   on_init = M.on_init,
--   capabilities = M.capabilities,
--   settings = {
--     pyright = {
--       -- Using Ruff's import organizer
--       disableOrganizeImports = true,
--     },
--     -- python = {
--     --   analysis = {
--     --     -- Ignore all files for analysis to exclusively use Ruff for linting
--     --     ignore = { "*" },
--     --   },
--     -- },
--   },
-- }
