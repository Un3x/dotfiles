
-- movement
Map("n", "<C-h>", "<C-w>h")
Map("n", "<C-j>", "<C-w>j")
Map("n", "<C-k>", "<C-w>k")
Map("n", "<C-l>", "<C-w>l")

-- terminal
Map("t", "<C-h>", "<cmd>wincmd h<CR>")
Map("t", "<C-j>", "<cmd>wincmd j<CR>")
Map("t", "<C-k>", "<cmd>wincmd k<CR>")
Map("t", "<C-l>", "<cmd>wincmd l<CR>")

-- resize
Map("n", "<C-Up>", ":resize +2<CR>")
Map("n", "<C-Down>", ":resize -2<CR>")
Map("n", "<C-Left>", ":vertical resize +2<CR>")
Map("n", "<C-Right>", ":vertical resize -2<CR>")

-- terminal
Map("t", "<C-Up>", "<cmd>resize +2<CR>")
Map("t", "<C-Down>", "<cmd>resize -2<CR>")
Map("t", "<C-Left>", "<cmd>vertical resize -2<CR>")
Map("t", "<C-Right>", "<cmd>vertical resize +2<CR>")

-- text editing
Map("v", "J", ":m '>+1<CR>gv=gv")
Map("v", "K", ":m '<-2<CR>gv=gv")
Map("v", "<", "<gv")
Map("v", ">", ">gv")

-- buffers
Map("n", "<TAB>", ":bn<CR>")
Map("n", "<S-TAB>", ":bp<CR>")
Map("n", "<leader>bd", ":bd<CR>")

-- telescope

local builtin = require('telescope.builtin')
Map('n', '<leader>ff', builtin.find_files, {})
Map('n', '<leader>fg', builtin.live_grep, {})
Map('n', '<leader>fb', builtin.buffers, {})
Map('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set("n", "<leader>fn", function()
  require("noice").cmd("telescope")
end)

vim.keymap.set("n", "<leader>nd", function()
  require("noice").cmd("dismiss")
end)

-- LSP

Map("n", "<leader>gd", ":lua vim.lsp.buf.definition()<CR>")
Map("n", "<leader>gi", ":lua vim.lsp.buf.implementation()<CR>")
Map("n", "K", ":lua vim.lsp.buf.hover()<CR>")
Map("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>")
Map("n", "<leader>gr", ":lua vim.lsp.buf.references()<CR>")

Map("n", "<leader>e", "<cmd>NvimTreeFindFile<CR>")
Map("n", "<leader>b", "<cmd>NvimTreeToggle<CR>")

