return {
  {
    'nvim-treesitter/nvim-treesitter',
    enabled = true,
    opts = {
      ensure_installed = {
        "python",
        "lua",
        "json",
        "bash"
      },
      ignore_install = {
        "jsonc"
      },
      highlight = {
        enable = true,
        disable = { "jsonc" },
      },
      indent = {
        enable = true,
        disable = { "jsonc" },
      },
      fold = {
        enable = true,
        disable = { "jsonc", "python" },
      },
    },
  },
}
