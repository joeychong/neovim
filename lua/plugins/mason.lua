return {
  {
    "williamboman/mason.nvim",
    opts = {}
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { 'lua_ls', 'ts_ls', 'volar' },
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
        -- configuration to support vue
        volar = function()
          local lspconfig = require("lspconfig")
          lspconfig.volar.setup {}
        end,
        ts_ls = function()
          local lspconfig = require("lspconfig")
          local vue_typescript_plugin_path = vim.fn.stdpath('data')
            .. '/mason/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin'
          lspconfig.ts_ls.setup {
            init_options = {
              plugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vue_typescript_plugin_path,
                  languages = { "vue" },
                },
              },
            },
            filetypes = {
              "javascript",
              "typescript",
              "javascriptreact",
              "typescriptreact",
              "vue",
            },
            single_file_support = false,
          }
        end,
        -- end of vue support configuration
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
