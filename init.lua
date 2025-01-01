-- load lazy vim
require("config.lazy")

-- set vim behavior
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
-- vim.g.mapleader = " "
vim.opt.number = true
-- vim.opt.relativenumber = true

-- custom key mapping
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a', { noremap = true, silent = true })
vim.keymap.set('n', '<C-t>', ':tabnew<CR>', { noremap = true, silent = true })

-- enable markdown code block syntax lighlighting
vim.g.markdown_fenced_languages = {
  "ts=typescript",
  "js=javascript",
  "json=javascript",
  "html",
  "css",
  "bash=sh",
  "python",
  "lua",
  "yaml",
  "toml"
}

-- enable copy and paste from native clipboard
vim.opt.clipboard = "unnamedplus"

-- enable load local neovim config
local local_config = vim.fn.getcwd() .. '/.nvim.lua'
if vim.loop.fs_stat(local_config) then
  vim.cmd('luafile ' .. local_config)
end
