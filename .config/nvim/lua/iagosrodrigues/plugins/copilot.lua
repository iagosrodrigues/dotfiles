return {
    "zbirenbaum/copilot.lua",
    lazy = true,
    event = "InsertEnter",
    cmd = "Copilot",
    opts = {
        suggestion = {
            auto_trigger = true,
            keymap = {
                accept = "<C-y>",
            }
        }
    }
}
