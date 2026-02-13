require'cmp'.setup {
  sources = {
    { name = 'copilot' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' }
  },
  mapping = {
    ['<CR>'] = require('cmp').mapping.confirm({ select = false }),
    ['<C-Space>'] = require('cmp').mapping.complete(),
    ['<C-n>'] = require('cmp').mapping.select_next_item(),
    ['<C-p>'] = require('cmp').mapping.select_prev_item(),
    ['<Tab>'] = require('cmp').mapping(function(fallback)
      if require('cmp').visible() then
        require('cmp').select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = require('cmp').mapping(function(fallback)
      if require('cmp').visible() then
        require('cmp').select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }
}

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- The following example advertise capabilities to `clangd`.
require'lspconfig'.clangd.setup {
  capabilities = capabilities,
}
