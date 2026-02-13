-- trouble-config.lua
local trouble = require("trouble")

trouble.setup({
  position = "bottom",
  icons = true,
  mode = "workspace_diagnostics",
  auto_close = true,
  auto_preview = true,
  use_diagnostic_signs = true,
})

-- Set up keymaps manually
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document Diagnostics" })
vim.keymap.set("n", "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace Diagnostics" })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble quickfix<cq>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", { desc = "Quickfix List" })
