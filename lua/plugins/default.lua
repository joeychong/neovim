return {
  -- I have a separate config.mappings file where I require which-key.
  -- With lazy the plugin will be automatically loaded when it is required somewhere
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here

      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      spec = {
        { '<leader>c', group = '[C]ode' },
        { '<leader>f', group = '[F]uzzy Search' }
      }
    },
    --[[keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },

    },--]]
  },
}
