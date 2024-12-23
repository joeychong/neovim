return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "lua", "vim", "vimdoc", "javascript", "html", "bash", "awk", "typescript", "java", "sql" , "go"},
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
  }
}
