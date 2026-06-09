local source = {}

local cache = {
  tracks = {},
  last_update = 0,
}

local function run(cmd)
  local handle = io.popen(cmd)
  if not handle then
    return ""
  end
  local result = handle:read("*a")
  handle:close()
  return result
end

-- ambil file name dari path
local function basename(path)
  return path:match("([^/]+)$") or path
end

local function load_tracks()
  local out = run("mpc listall")
  local list = {}

  for line in out:gmatch("[^\n]+") do
    table.insert(list, line)
  end

  cache.tracks = list
  cache.last_update = os.time()
end

local function get_tracks()
  if #cache.tracks == 0 then
    load_tracks()
  end

  local items = {}
  for _, line in ipairs(cache.tracks) do
    table.insert(items, {
      label = basename(line), -- tampil cuma nama file
      insertText = line, -- tetap full path untuk playlist
      kind = 1,
    })
  end

  return items
end

function source:new()
  return setmetatable({}, { __index = source })
end

function source:is_available()
  local name = vim.api.nvim_buf_get_name(0)
  return name:match("%.m3u$") ~= nil
end

function source:get_trigger_characters()
  return { "/", ":" }
end

function source:complete(_, callback)
  callback({
    items = get_tracks(),
    isIncomplete = true,
  })
end

return source
