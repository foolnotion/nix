local api, cmd, fn, g = vim.api, vim.cmd, vim.fn, vim.g
local opt, wo = vim.opt, vim.wo
local fmt = string.format

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

opt.expandtab = true
opt.linespace = 1
opt.nu = true
opt.backspace = 'indent,eol,start'
opt.mouse = 'a'
opt.autoindent = true
opt.ruler = true
opt.showcmd = true
opt.incsearch = true
opt.relativenumber = true
opt.smartindent = true
opt.tabstop = 4
opt.shiftwidth = 4

map('', '<leader>c', '"+y')
map('', '<F2>', ':w!<CR>')
map('', '<F3>', ':NERDTreeToggle<CR>')
map('', '<F4>', ':bdelete<CR>')
map('', '<F5>', ':bprevious<CR>')
map('', '<F6>', ':bnext<CR>')

require'lspconfig'.clangd.setup{}
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
}
require('lualine').setup()
