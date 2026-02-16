-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.relativenumber = false

vim.keymap.set("n", "<down>", "gj")
vim.keymap.set("n", "<up>", "gk")
