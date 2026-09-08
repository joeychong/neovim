return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")
    local languages = {
      "lua",
      "vim",
      "vimdoc",
      "javascript",
      "html",
      "bash",
      "awk",
      "typescript",
      "java",
      "sql",
      "go",
      "markdown",
      "markdown_inline",
    }

    treesitter.setup()
    treesitter.install(languages)

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if lang and pcall(vim.treesitter.start, args.buf, lang) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
