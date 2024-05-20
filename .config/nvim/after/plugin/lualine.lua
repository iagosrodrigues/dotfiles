require('lualine').setup({
    options = {
        icons_enabled = false,
        -- theme = 'molokai',
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff',
            {
                'diagnostics',
                sources = { "nvim_diagnostic" },
                -- symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' }
                symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' }
            }
        },
        lualine_y = {
            { 'copilot', show_colors = true },
            'encoding',
            'fileformat',
            'filetype'
        }
    },
})
