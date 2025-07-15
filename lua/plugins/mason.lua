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
      -- version 2.2.10
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
      local vue_plugin = {
        name = '@vue/typescript-plugin',
        location = vue_typescript_plugin_path,
        languages = { 'vue' },
        configNamespace = 'typescript',
      }
      local vtsls_config = {
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
      }

      local vue_ls_config = {
        on_init = function(client)
          client.handlers['tsserver/request'] = function(_, result, context)
            local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
            if #clients == 0 then
              vim.notify('Could not find `vtsls` lsp client, `vue_ls` would not work without it.', vim.log.levels.ERROR)
              return
            end
            local ts_client = clients[1]

            local param = table.unpack(result)
            local id, command, payload = table.unpack(param)
            ts_client:exec_cmd({
              title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
              command = 'typescript.tsserverRequest',
              arguments = {
                command,
                payload,
              },
            }, { bufnr = context.bufnr }, function(_, r)
                local response_data = { { id, r.body } }
                ---@diagnostic disable-next-line: param-type-mismatch
                client:notify('tsserver/response', response_data)
              end)
          end
        end,
      }
      -- nvim 0.11 or above
      vim.lsp.config('vtsls', vtsls_config)
      vim.lsp.config('vue_ls', vue_ls_config)
      vim.lsp.enable({'vtsls', 'vue_ls'})

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action'})
    end,
  }
}
