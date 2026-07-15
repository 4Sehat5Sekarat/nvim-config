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

-- CONFIG
local config = {
  mpc_cmd = "mpc",
}

-- helper: run shell
local function run(cmd)
  local handle = io.popen(cmd)
  if not handle then
    return {}
  end
  local result = handle:read("*a")
  handle:close()
  return result
end

-- ambil semua track dari MPD
local function get_tracks()
  local out = run(config.mpc_cmd .. " listall")
  local list = {}
  for line in out:gmatch("[^\n]+") do
    table.insert(list, line)
  end
  return list
end

-- insert ke buffer
local function insert(text)
  vim.api.nvim_put({ text }, "c", true, true)
end

-- picker sederhana
local function pick(list, cb)
  vim.ui.select(list, {
    prompt = "MPD Track",
  }, function(choice)
    if choice then
      cb(choice)
    end
  end)
end

-- insert track ke playlist
local function insert_track()
  pick(get_tracks(), function(choice)
    insert(choice)
  end)
end

local function enable()
  vim.b.mpd_playlist = true

  vim.keymap.set("n", "<leader>ms", insert_track, {
    buffer = true,
    desc = "MPD insert track",
  })

  -- Load Autocomplete
  local cmp = require("cmp")
  cmp.setup({
    sources = {
      { name = "mpd" },
    },
  })

  cmp.register_source("mpd", source.new())
  print("MPD playlist mode aktif")
end
-- setup autocmd + commands
-- aktif hanya di m3u
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.m3u",
  callback = function()
    enable()
  end,
})

vim.api.nvim_create_user_command("MPDInsert", function()
  insert_track()
end, {})

vim.api.nvim_create_user_command("MPDRefresh", function()
  print("refresh tracks")
  get_tracks()
end, {})

-- mode playlist editor
