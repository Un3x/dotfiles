require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    html = { "prettierd", "prettier", stop_after_first = true },
    css = { "prettierd", "prettier", stop_after_first = true },
    scss = { "prettierd", "prettier", stop_after_first = true },
    markdown = { "prettierd", "prettier", stop_after_first = true },
    yaml = { "prettierd", "prettier", stop_after_first = true },
    ruby = { "rubocop" },
    sh = { "shfmt" },
  },
  format_on_save = {
    timeout_ms = 3000,
    lsp_fallback = true,
  },
})

-- Add keymap for triggering conform manually with leader+h
vim.keymap.set("n", "<leader>h", function()
  require("conform").format()
end, { desc = "Format current buffer with conform" })
