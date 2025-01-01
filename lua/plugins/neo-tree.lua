return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  init = function()
    vim.keymap.set('n', '<C-e>', ':Neotree toggle left<CR>', { noremap = true, silent = true, desc = 'Toggle Neo-tree on the left' })
  end,
  opts = {
    close_if_last_window = true, -- Close Neo-tree if it's the last window
    event_handlers = {
      {
        event = "file_opened",
        handler = function()
          require("neo-tree.command").execute({ action = "close" })
        end,
      },
    },
    filesystem = {
      filtered_items = {
        --visible = true, -- Show hidden files
        hide_dotfiles = false, -- Do not hide dotfiles (e.g., .gitignore)
        --hide_gitignored = false, -- Show gitignored files
        hide_by_name = {
          "node_modules", -- Ignore this folder
          ".git",
        },
      },
      follow_current_file = {
        enabled = true,
      },
    },
  }
}
