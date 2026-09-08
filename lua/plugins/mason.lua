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
        ensure_installed = { 'lua_ls', 'ts_ls', 'vue_ls' },
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
        .. '/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin'
      --[[ vim.lsp.config('lua_ls', {})
      vim.lsp.config('vue_ls', {})
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
      }) --]]
      local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
      local vue_plugin = {
        name = '@vue/typescript-plugin',
        location = vue_typescript_plugin_path,
        languages = { 'vue' },
        configNamespace = 'typescript',
      }
      local ts_ls_config = {
        init_options = {
          plugins = {
            vue_plugin,
          },
        },
        filetypes = tsserver_filetypes,
      }
      --[[local vtsls_config = {
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                vue_plugin,
              },
            },
          },
        },
        filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
      }--]]

      -- nvim 0.11 or above
      -- vim.lsp.config('vtsls', vtsls_config)
      vim.lsp.config('vue_ls', {})
      vim.lsp.config('ts_ls', ts_ls_config)
      -- vim.lsp.enable({'vtsls', 'vue_ls'})
      vim.lsp.enable({'ts_ls', 'vue_ls'})

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action'})
    end,
  }
}
