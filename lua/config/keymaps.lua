-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keyset = vim.keymap.set

keyset("t", "<C-b>", [[<C-\><C-n>]], { noremap = true, silent = true })
keyset("n", "<leader>qQ", "<cmd>lua Snacks.dashboard.open()<CR>", {
  noremap = true,
  silent = true,
  buffer = true,
  desc = "Back to starter",
})

keyset("n", "<leader>qQ", "<cmd>lua Snacks.dashboard.open()<CR>", {
  noremap = true,
  silent = true,
  buffer = true,
  desc = "Back to starter",
})
