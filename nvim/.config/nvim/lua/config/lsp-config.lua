local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})

require('mason-lspconfig').setup({
  -- Mason-lspconfig uses lspconfig server names, not Mason package names
  ensure_installed = {
    'intelephense',
    'html',
    'solargraph',
    'sqlls',
    'jsonls',
    'ts_ls',  -- typescript server is called ts_ls in mason-lspconfig, not tsserver
    'cssls',
    'yamlls'
  },
  handlers = {
    lsp_zero.default_setup,
  },
})

-- Use vim.lsp.config (Neovim 0.11+) instead of deprecated require('lspconfig')
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
      },
    },
  },
})
vim.lsp.enable('lua_ls')
