local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require('lspconfig')

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "tsserver",
        "rust_analyzer",
        "lua_ls"
    },
    handlers = {
        function(server_name)
            require("lspconfig")[server_name].setup {}
            capabilities = capabilities
        end,
        rust_analyzer = function()
            lspconfig.rust_analyzer.setup {
                capabilities = capabilities,
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = {
                            command = "clippy"
                        }
                    }
                }
            }
        end,
        lua_ls = function()
            lspconfig.lua_ls.setup {
                capabilities = capabilities,
                on_init = function(client)
                    local path = client.workspace_folders[1].name
                    if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                        client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                            Lua = {
                                runtime = {
                                    -- Tell the language server which version of Lua you're using
                                    -- (most likely LuaJIT in the case of Neovim)
                                    version = 'LuaJIT'
                                },
                                -- Make the server aware of Neovim runtime files
                                workspace = {
                                    checkThirdParty = false,
                                    library = {
                                        vim.env.VIMRUNTIME
                                        -- "${3rd}/luv/library"
                                        -- "${3rd}/busted/library",
                                    }
                                    -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                                    -- library = vim.api.nvim_get_runtime_file("", true)
                                }
                            }
                        })

                        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                    end
                    return true
                end
            }
        end
    }
})
