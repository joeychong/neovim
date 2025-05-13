return {
  {
    --"williamboman/mason.nvim",
    "mason-org/mason.nvim",
    opts = {}
  },
  {
    --"williamboman/mason-lspconfig.nvim",
    "mason-org/mason-lspconfig.nvim",
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = { 'lua_ls', 'ts_ls', 'volar' },
        automatic_installation = true,
        -- Default handler for all installed servers
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup({
              --on_attach = function(client, bufnr)
                -- Keybindings or custom LSP behavior can go here
              --end,
              capabilities = require('cmp_nvim_lsp').default_capabilities(), -- Add autocomplete support if using nvim-cmp
            })
            --[[vim.lsp.config(server_name, {
              capabilities = require('cmp_nvim_lsp').default_capabilities(), -- Add autocomplete support if using nvim-cmp
            })--]]
          end,
        }
      })
    end,
    dependencies = {
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp", -- Ensure this is loaded before mason-lspconfig config runs if it's used in capabilities
    }
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      --local lspconfig = require("lspconfig")
      --lspconfig.lua_ls.setup({})
      local vue_typescript_plugin_path = vim.fn.stdpath('data')
        .. '/mason/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin'
      vim.lsp.config('lua_ls', {})
      vim.lsp.config('volar', {})
      vim.lsp.config('ts_ls', {
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
        -- capabilities = require('cmp_nvim_lsp').default_capabilities(),
        single_file_support = false,
      })
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action'})
    end,
  }
}
