-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.opt.termguicolors = true
vim.o.background = "dark"
vim.cmd("colorscheme simple")

vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#2a2a2a" })
