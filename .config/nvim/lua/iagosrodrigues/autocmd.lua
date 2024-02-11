IagoGroup = vim.api.nvim_create_augroup("iagosrodrigues", {})

vim.api.nvim_create_autocmd("VimLeave", {
	group = IagoGroup,
	pattern = "*",
	callback = function()
		-- vim.opt.guicursor = "n-v-c:block-Cursor"
		vim.opt.guicursor = ""
		vim.fn.chansend(vim.v.stderr, "\x1b[ q")
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = IagoGroup,
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		local opts = { buffer = ev.buf }

		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)

		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)

		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)

		vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
		vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

		vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)

		vim.keymap.set("n", "<leader>f", function()
			require("conform").format({ bufnr = ev.buf, timeout_ms = 500, lsp_fallback = true })
		end, opts)
	end,
})
