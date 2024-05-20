IagoGroup = vim.api.nvim_create_augroup("iagosrodrigues", {})

Autocmd = vim.api.nvim_create_autocmd

Autocmd("TextYankPost", {
    group = IagoGroup,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 40,
        })
    end,
})

Autocmd("VimLeave", {
    group = IagoGroup,
    pattern = "*",
    callback = function()
        -- vim.opt.guicursor = "n-v-c:block-Cursor"
        vim.opt.guicursor = ""
        vim.fn.chansend(vim.v.stderr, "\x1b[ q")
    end,
})

Autocmd("LspAttach", {
    group = IagoGroup,
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
        end

        -- vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        local opts = { buffer = ev.buf }

        vim.keymap.set("n", "<leader>ie", function() vim.lsp.inlay_hint.enable(true) end, opts)
        vim.keymap.set("n", "<leader>id", function() vim.lsp.inlay_hint.enable(false) end, opts)

        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)

        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)

        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set({ "n", 'v' }, "<leader>ca", vim.lsp.buf.code_action, opts)

        vim.keymap.set(
            "n",
            "<leader>q",
            vim.diagnostic.setloclist,
            { desc = "Open diagnostic [Q]uickfix list", buffer = ev.buf }
        )

        if client.supports_method('textDocument/rename') then
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        end

        vim.keymap.set("n", "<leader>f", function()
            require("conform").format({ bufnr = ev.buf, timeout_ms = 500, lsp_fallback = true })
            -- vim.lsp.buf.format({ async = true })
        end, opts)
    end,
})
