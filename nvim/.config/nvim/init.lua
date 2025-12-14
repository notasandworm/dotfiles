-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.opt.termguicolors = true
vim.o.background = "dark"
vim.cmd("colorscheme simple")
vim.cmd("set nolist")

-- Map Ctrl + PgUp to go to the previous tab
vim.keymap.set("n", "<C-PageUp>", ":tabprevious<CR>", { desc = "Previous tab" })
-- Map Ctrl + PgDn to go to the next tab
vim.keymap.set("n", "<C-PageDown>", ":tabnext<CR>", { desc = "Next tab" })
