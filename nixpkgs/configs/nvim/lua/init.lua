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
opt.relativenumber = false 
opt.smartindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.clipboard = 'unnamed,unnamedplus'

map('', '<leader>c', '"+y')
map('', '<F2>', ':w!<CR>')
map('', '<F3>', ':NERDTreeToggle<CR>')
map('', '<F4>', ':bdelete<CR>')
map('', '<F5>', ':bprevious<CR>')
map('', '<F6>', ':bnext<CR>')

require'lspconfig'.clangd.setup{on_attach=require'completion'.on_attach}
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
}
require('lualine').setup()

-- Use <Tab> and <S-Tab> to navigate through popup menu
vim.api.nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
vim.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})

-- Set completeopt to have a better completion experience
vim.o.completeopt="menuone,noinsert,noselect"

-- Avoid showing message extra message when using completion
vim.o.shortmess = vim.o.shortmess .. "c"

-- Chain completion list
vim.g.completion_chain_complete_list = {
            default = {
              default = {
                  { complete_items = { 'lsp', 'snippet' }},
                  { mode = '<c-p>'},
                  { mode = '<c-n>'}},
              comment = {},
              string = { { complete_items = { 'path' }} }}}

-- Latexmk configuration
vim.g.vimtex_compiler_latexmk = {
     options = {
       '-pdf',
       '-shell-escape',
       '-verbose',
       '-file-line-error',
       '-synctex=1',
       '-interaction=nonstopmode',
     }}
