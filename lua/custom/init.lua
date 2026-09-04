-- Auto import every lua files on `custom_path` where `custom_path` used to be ignored on git
local custom_path = vim.fn.stdpath("config") .. "/lua/custom/lua/"
local files = vim.fn.globpath(custom_path, "*.lua", false, true)

for _, file in ipairs(files) do
  local name = vim.fn.fnamemodify(file, ":t:r")
  require("custom.lua." .. name)
  vim.print("custom.lua." .. name)
end
