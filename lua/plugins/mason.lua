return {
  {
    --"williamboman/mason.nvim",
    "mason-org/mason.nvim",
    opts = {}
  },
  {
    --"williamboman/mason-lspconfig.nvim",
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "lua_ls", "vue_ls", "vtsls" },
      automatic_enable = false,
    },
    dependencies = {
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp", -- Ensure this is loaded before mason-lspconfig config runs if it's used in capabilities
    }
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local vue_typescript_plugin_path = vim.fn.stdpath('data')
        .. '/mason/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin'
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

            local unpack = table.unpack or unpack
            local param = unpack(result)
            local id, command, payload = unpack(param)
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
      vim.lsp.config("lua_ls", { capabilities = capabilities })
      vim.lsp.config("vtsls", vim.tbl_deep_extend("force", vtsls_config, {
        capabilities = capabilities,
      }))
      vim.lsp.config("vue_ls", vim.tbl_deep_extend("force", vue_ls_config, {
        capabilities = capabilities,
      }))
      vim.lsp.enable({ "lua_ls", "vtsls", "vue_ls" })

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action'})
    end,
  }
}
