local M = {}

local function url_decode(str)
  return str:gsub("%%(%x%x)", function(hex)
    return string.char(tonumber(hex, 16))
  end)
end

local function url_encode(str)
  return str:gsub("([^%w%-_%.~])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
end

vim.api.nvim_create_user_command("StripSpace", function(opts)
  local start_line = opts.line1
  local end_line = opts.line2

  -- ambil lines
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  -- join jadi satu string
  local text = table.concat(lines, " ")

  -- normalize whitespace (tabs, newline, multi space)
  text = text:gsub("%s+", " ")

  -- replace range dengan 1 line
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, { text })
end, { range = true })

-- Create Command
function M.setup()
  -- Create user command named URL
  vim.api.nvim_create_user_command("URL", function(opts)
    local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)

    for i, line in ipairs(lines) do
      if opts.args == "encode" then
        lines[i] = url_encode(line)
      elseif opts.args == "decode" then
        lines[i] = url_decode(line)
      end
    end

    vim.api.nvim_buf_set_lines(0, opts.line1 - 1, opts.line2, false, lines)
  end, {
    range = true,
    nargs = 1,
    complete = function()
      return { "decode", "encode" }
    end,
  })
end

return M
