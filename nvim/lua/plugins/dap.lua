local dap = require("dap")
local dap_ui = require("dapui")
local dap_go = require("dap-go")

dap_go.setup()
dap_ui.setup()

-- Open DAP UI when a debug session starts.
dap.listeners.after.event_initialized["dapui_config"] = function()
  dap_ui.open()
end

-- Close DAP UI when a debug session ends.
dap.listeners.before.event_terminated["dapui_config"] = function()
  dap_ui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dap_ui.close()
end

vim.keymap.set("n", "<F9>", dap.continue, { desc = "DAP: Continue" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP: Step out" })
vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>dt", dap_go.debug_test)

vim.keymap.set("n", "<leader>du", dap_ui.toggle)
