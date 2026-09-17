return {
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFileHistory",
    },
    keys = {
      { "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
      { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
      { "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
      { "<leader>dH", "<cmd>DiffviewFileHistory<cr>", desc = "Repository history" },
    },
    opts = {},
  },
}
