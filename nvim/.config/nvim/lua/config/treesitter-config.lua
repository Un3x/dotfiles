require("nvim-treesitter").install({ "c", "lua", "vim", "vimdoc", "query", "ruby", "typescript", "javascript", "html", "css", "json", "yaml", "bash", "dockerfile", "go", "php", "regex", "comment", "markdown", "markdown_inline" })

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
