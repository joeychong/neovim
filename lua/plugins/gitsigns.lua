return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame line" },
      { "<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle inline blame" },
    },
    opts = {
      current_line_blame = true,
    },
  },
}
