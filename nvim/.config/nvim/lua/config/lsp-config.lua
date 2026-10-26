vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
    end

    map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
    map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
    map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
    map('n', 'go', vim.lsp.buf.type_definition, 'Go to type definition')
    map('n', 'gl', vim.diagnostic.open_float, 'Show diagnostic')
    map('n', '<F2>', vim.lsp.buf.rename, 'Rename symbol')
    map({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end, 'Format')
    map({ 'n', 'x' }, '<F4>', vim.lsp.buf.code_action, 'Execute code action')
  end,
})

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
