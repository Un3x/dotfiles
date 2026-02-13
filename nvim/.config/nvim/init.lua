vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable netrw at the very start
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Add file type association for yml files
vim.filetype.add({
  extension = {
    yml = "yaml",
  },
})

-- Core setup
require("config.lazy-config")
require("plugins")
require("autocmd")
require("keymaps")
require("options")

-- Theme configuration
require("config.tokyonight-config")
vim.cmd[[colorscheme tokyonight]]

-- UI configurations
require("config.noice-config")
require("config.bufferline-config")
require("config.nvim-tree-config")

-- Editor features
require("config.illuminate-config")
require("config.treesitter-config")
require("config.telescope-config")
require("config.flit-config")

-- Language & completion
require("config.lsp-config")
require("config.cmp-config")
require("config.copilot-config")
require("config.conform-config")
require("config.trouble-config")
