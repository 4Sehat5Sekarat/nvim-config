-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keyset = vim.keymap.set

keyset("t", "<C-o>", [[<C-\><C-n>]], { noremap = true, silent = true })

keyset("n", "<leader>fd", ":lua Snacks.dashboard()<CR>", {
  noremap = true,
  silent = true,
  desc = "Open dashboard",
})
