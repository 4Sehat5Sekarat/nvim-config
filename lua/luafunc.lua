local path = vim.fs.joinpath(vim.fn.getcwd(), ".LuaFunction.lua")
vim.api.nvim_create_user_command("LuaFunctionCreate", function()
  if vim.uv.fs_stat(path) then
    vim.notify("File exist")
    return
  end

  local file = io.open(path, "w")
  local text = [[
-- WARNING:
-- This file was not part of the project, if it is then remove this comment.
-- This file was used to call a function

local M = {}
-- Your lua function goes here

function M.example(n)
	n = tonumber(n) or 1
	local t = {}
	for _ = 1, n do
		table.insert(t, "Hello World")
	end
	return table.concat(t, "\n")
end

return M]]
  if file then
    file:write(text)
    file:close()
  end
end, {})

vim.api.nvim_create_user_command("LuaFunction", function(opts)
  local chunk = loadfile(path)

  local start_line = opts.line1
  local end_line = opts.line2

  if not chunk then
    vim.notify("File not found", vim.log.levels.ERROR)
    return
  end

  local ok, funcs = pcall(chunk)
  if not ok then
    vim.notify(funcs, vim.log.levels.ERROR)
    return
  end

  local args = vim.split(opts.args, "%s+", { trimempty = true })
  local name = table.remove(args, 1)

  local fn = funcs[name]
  if type(fn) ~= "function" then
    vim.notify(("Function '%s' not found"):format(name))
    return
  end

  local ok, result = pcall(fn, unpack(args))
  if not ok then
    vim.notify(result, vim.log.levels.ERROR)
    return
  end

  if result then
    local lines = vim.split(result, "\n", { plain = true })

    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
  end
end, {
  range = true,
  nargs = "+",
  complete = function()
    local chunk = loadfile(path)
    if not chunk then
      return {}
    end

    local ok, funcs = pcall(chunk)
    if not ok then
      return {}
    end

    local ret = {}

    for name, value in pairs(funcs) do
      if type(value) == "function" then
        table.insert(ret, name)
      end
    end

    table.sort(ret)

    return ret
  end,
})
