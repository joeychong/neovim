return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional for icons
  opts = {
    options = {
      icons_enabled = true,
      theme = 'auto', -- Adjust theme if needed
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {},
      always_divide_middle = true,
    },
    sections = {
      lualine_a = {'mode'},             -- Show current mode
      lualine_b = {'branch', 'diff'},   -- Show Git branch and diff status
      lualine_c = {'filename'},         -- Show current filename
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},         -- Show progress in file
      lualine_z = {'location'}          -- Show cursor location
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    extensions = {'fugitive', 'nvim-tree'}
  }
}
