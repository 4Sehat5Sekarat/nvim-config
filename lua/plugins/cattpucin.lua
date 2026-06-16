return {
  "catppuccin/nvim",
  name = "catppuccin",
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
      },

      transparent_background = true,
      show_end_of_buffer = false,
      term_colors = false,

      dim_inactive = {
        enabled = false, -- Ubah ke true bila mau gelapkan window tak aktif
        shade = "dark",
        percentage = 0.15,
      },

      no_italic = true,
      no_bold = false,
      no_underline = false,

      -- Gaya umum (highlight groups)
      styles = {
        comments = {},
        conditionals = {},
        -- grup lain dibiarkan kosong → gunakan gaya default tema
      },

      -- Gaya LSP
      lsp_styles = {
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
        },
        inlay_hints = {
          background = true,
        },
      },

      color_overrides = {}, -- isi bila ingin menimpa warna palet
      custom_highlights = {}, -- isi bila ingin highlight khusus

      default_integrations = true,
      auto_integrations = true,

      -- Integrasi dengan plugin lain
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        notify = false, -- ubah ke true bila pakai nvim-notify
        mini = {
          enabled = true,
          indentscope_color = "mocha", -- beri nama warna (misal "lavender") bila ingin custom
        },
        -- Tambahkan integrasi lain di sini bila diperlukan,
        -- contoh: telescope = true, treesitter = true, lualine = true, dll.
      },
    })
  end,
}
