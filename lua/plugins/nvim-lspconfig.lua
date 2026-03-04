return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
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
