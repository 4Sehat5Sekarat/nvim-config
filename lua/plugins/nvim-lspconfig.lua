return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ruff = {
        mason = false,
      },
      lua_ls = {
        mason = false,
        cmd = { "lua-language-server" },
      },
      marksman = {
        mason = false,
      },
    },
  },
}
