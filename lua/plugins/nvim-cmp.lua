return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require("cmp")

    opts.preselect = cmp.PreselectMode.None

    opts.completion = {
      completeopt = "menu,menuone,noinsert,noselect",
    }

    opts.mapping = cmp.mapping.preset.insert({
      ["<CR>"] = cmp.mapping.confirm({ select = false }), -- tidak auto pilih
    })

    return opts
  end,
}
