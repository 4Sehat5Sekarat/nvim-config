-- yuck.nvim (single file, treesitter-ready + vim fallback)

local M = {}

-- =========================
-- FILETYPE
-- =========================
vim.filetype.add({
  extension = {
    yuck = "yuck",
  },
})

-- =========================
-- HIGHLIGHT GROUPS (VIM STYLE COMPAT)
-- =========================
local function setup_highlight()
  local hl = vim.api.nvim_set_hl

  -- core yuck.vim style groups
  hl(0, "yuckComment", { link = "Comment" })
  hl(0, "yuckString", { link = "String" })
  hl(0, "yuckNumber", { link = "Number" })
  hl(0, "yuckKeyword", { link = "Keyword" })
  hl(0, "yuckFunction", { link = "Function" })
  hl(0, "yuckProperty", { link = "Identifier" })
  hl(0, "yuckParen", { link = "Delimiter" })
  hl(0, "yuckExpr", { link = "Special" })
end

-- =========================
-- FALLBACK SYNTAX (like yuck.vim)
-- =========================
local function setup_vim_syntax()
  vim.cmd([[
    syntax clear

    " comments
    syntax match yuckComment ";;.*$"

    " strings
    syntax region yuckString start=+"+ skip=+\\\\\|\\"+ end=+"+

    " numbers
    syntax match yuckNumber "\v\d+"

    " keywords (core eww/yuck forms)
    syntax keyword yuckKeyword box button label image list scroll window defwidget deflisten defpoll defvar

    " parentheses / lisp structure
    syntax match yuckParen "[()]"

    " expressions ${...}
    syntax region yuckExpr start="${" end="}" contains=yuckString,yuckNumber,yuckExpr

    highlight link yuckComment Comment
    highlight link yuckString String
    highlight link yuckNumber Number
    highlight link yuckKeyword Keyword
    highlight link yuckParen Delimiter
    highlight link yuckExpr Special
  ]])
end

-- =========================
-- TREE-SITTER (modern path)
-- =========================
local function setup_treesitter()
  local ok, ts = pcall(require, "nvim-treesitter.configs")
  if not ok then
    return false
  end

  ts.setup({
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "yuck" },
    },
  })

  return true
end

-- =========================
-- AUTO SETUP
-- =========================
function M.setup()
  setup_highlight()

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "yuck",
    callback = function()
      vim.bo.commentstring = ";; %s"

      -- try treesitter first, fallback if not available
      local ok = setup_treesitter()
      if not ok then
        setup_vim_syntax()
      end
    end,
  })
end

return M
