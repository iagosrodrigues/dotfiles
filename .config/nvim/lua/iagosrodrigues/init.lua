require("iagosrodrigues.options")
require("iagosrodrigues.remap")
require("iagosrodrigues.lazy")

vim.api.nvim_create_autocmd("VimLeave", {
    pattern = "*",
    callback = function()
        -- vim.opt.guicursor = "n-v-c:block-Cursor"
        vim.opt.guicursor = ""
        vim.fn.chansend(vim.v.stderr, "\x1b[ q")
    end
})
