return {
  {
    "williamboman/mason.nvim",
    opts = {}
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { 'lua_ls' },
      automatic_installation = true,
    },
    init = function()
      require('mason-lspconfig').setup_handlers({
        -- Default handler for all installed servers
        function(server_name)
          require('lspconfig')[server_name].setup({
            --on_attach = function(client, bufnr)
              -- Keybindings or custom LSP behavior can go here
            --end,
            capabilities = require('cmp_nvim_lsp').default_capabilities(), -- Add autocomplete support if using nvim-cmp
          })
        end,
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action'})
    end,
  }
}
