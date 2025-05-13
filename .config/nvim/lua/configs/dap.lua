local map = vim.keymap.set
local dap = require("dap")
local dapui = require("dapui")
local widgets = require("dap.ui.widgets")

dapui.setup()

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

map("n", "<F5>", dap.continue, { desc = "Continue debugger" })
map("n", "<F10>", dap.step_over, { desc = "Step over debugger" })
map("n", "<F11>", dap.step_into, { desc = "Step into debugger" })
map("n", "<F12>", dap.step_out, { desc = "Step out debugger" })
map("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
map("n", "<leader>B", dap.set_breakpoint, { desc = "Set breakpoint" })
map("n", "<leader>lp", function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
  { desc = "Set breakpoint" })
map("n", "<leader>dl", dap.run_last, { desc = "Run last breakpoint" })
map({ 'n', 'v' }, '<Leader>dh', widgets.hover, { desc = "Show hover" })
map({ 'n', 'v' }, '<Leader>dp', widgets.preview, { desc = "Show preview" })
map({ 'n', 'v' }, '<Leader>df', function()
  widgets.centered_float(widgets.frames)
end, { desc = "Show preview" })
map({ 'n', 'v' }, '<Leader>ds', function()
  widgets.centered_float(widgets.scopes)
end, { desc = "Show preview" })
