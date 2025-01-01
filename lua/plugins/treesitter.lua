return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "lua", "vim", "vimdoc", "javascript", "html", "bash", "awk", "typescript", "java", "sql" , "go", "markdown", "markdown_inline" },
    auto_install = true,
    sync_install = false,
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    indent = { enable = true },
  }
}
