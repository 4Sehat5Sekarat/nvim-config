local M = {}

-- CONFIG
M.config = {
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
  local out = run(M.config.mpc_cmd .. " listall")
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

-- setup autocmd + commands
function M.setup()
  -- aktif hanya di m3u
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.m3u",
    callback = function()
      M.enable()
    end,
  })

  vim.api.nvim_create_user_command("MPDInsert", function()
    insert_track()
  end, {})

  vim.api.nvim_create_user_command("MPDRefresh", function()
    print("refresh tracks")
    get_tracks()
  end, {})
end

-- mode playlist editor
function M.enable()
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

  cmp.register_source("mpd", require("mpd_playlist.cmpmpd").new())
  print("MPD playlist mode aktif")
end

return M
