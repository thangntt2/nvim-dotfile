syntax enable
set background=dark
set hidden
set switchbuf=usetab,newtab
set termguicolors
set rnu
set updatetime=300
set expandtab
set clipboard+=unnamedplus
set noswapfile
set signcolumn=yes
set smartcase
set ignorecase
set noshowmode
set showtabline=2
set completeopt=menuone,noselect

" set tab numbers
set guitablabel=%N:%M%t

" Disable old vi style
set nocompatible

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Indentation
set autoindent
set expandtab
set shiftwidth=2
set softtabstop=2

syntax on

set number
filetype indent on
filetype plugin on

set showmatch           " highlight matching [{()}]
set hlsearch            " highlight matches
set noautochdir         " root as working directory no matter how deep I am

" improve clipboard speed
let win32yank = resolve(exepath('win32yank.exe'))
let g:clipboard = {
  \ 'name': 'win32yank',
  \ 'copy': {
    \ '+': win32yank.' -i --crlf',
    \ '*': win32yank.' -i --crlf'
  \   },
  \ 'paste': {
    \ '+': win32yank.' -o --lf',
    \ '*': win32yank.' -o --lf'
  \   }
  \ }
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" Consistent movement
nnoremap J }
nnoremap K {
nnoremap L ^
nnoremap H 0

nnoremap <A-j> <C-W>j
nnoremap <A-k> <C-W>k
nnoremap <A-h> <C-W>h
nnoremap <A-l> <C-W>l

nnoremap <c-j> <c-e>
nnoremap <c-k> <c-y>
nnoremap <c-l> zl
nnoremap <c-h> zh

"netrw config
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

" Remap leader to space
let mapleader=" "

" Map jj to esc"
imap jj <Esc>

" Install plugins
if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  auto VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'jparise/vim-graphql'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'sodapopcan/vim-twiggy', { 'on': 'Twiggy' }    " git branch manager
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }   " fuzzy file searcher
Plug 'mhinz/vim-signify'                            " git diff
Plug 'justinmk/vim-sneak'
Plug 'styled-components/vim-styled-components', { 'branch': 'main', 'for': 'typescript.tsx' }
Plug 'pechorin/any-jump.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'gruvbox-community/gruvbox'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'kshenoy/vim-signature'
Plug 'arcticicestudio/nord-vim'
" LSP specific block
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'],
  \ }
call plug#end()

colorscheme nord

" Prettier
let g:prettier#autoformat = 1

" vim-sneak settings
let g:sneak#label = 1
let g:sneak#s_next = 1

" LeaderF settings
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
nnoremap <silent> <C-space> :Leaderf buffer<CR>
nnoremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e ")<CR>
nnoremap <silent> <C-P> :LeaderfFile<CR>

" Lightline settings
let g:lightline = {
  \ 'colorscheme': 'nord',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead'
  \ },
  \ 'enable': { 'tabline': 0 },
  \ 'component_expand': {'buffers': 'lightline#bufferline#buffers'},
  \ 'component_type': {'buffers': 'tabsel'}
  \ }


" Twiggy settings
nnoremap <silent> <leader>g :Twiggy<CR>

let t:is_transparent = 0
function! Toggle_transparent()
    if t:is_transparent == 0
        hi Normal guibg=NONE ctermbg=NONE
        let t:is_transparent = 1
    else
        set background=dark
        let t:is_tranparent = 0
    endif
endfunction
nnoremap <silent> <leader>t : call Toggle_transparent()<CR>

" NvimTree
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>
let g:nvim_tree_hijack_netrw = 0
let g:nvim_tree_disable_netrw = 0
let g:nvim_tree_follow = 1

" bufferline
lua << EOF
require("bufferline").setup{}
EOF

" LSP 
lua << EOF
require'lspconfig'.tsserver.setup{}
local saga = require 'lspsaga'
saga.init_lsp_saga()
EOF

" lsp provider to find the cursor word definition and reference
nnoremap <silent> gh <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>
" or use command LspSagaFinder

" code action
nnoremap <silent><leader>ca :Lspsaga code_action<CR>
vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>

" show hover doc
nnoremap <silent>K :Lspsaga hover_doc<CR>


" show signature help
nnoremap <silent> gs :Lspsaga signature_help<CR>

" rename
nnoremap <silent>gr :Lspsaga rename<CR>
" close rename win use <C-c> in insert mode or `q` in noremal mode or `:q`

" preview definition
nnoremap <silent>gd <Cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent>gD :Lspsaga preview_definition <CR>

" Lsp auto completion
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.source = {
  \ 'path': v:true,
  \ 'buffer': v:true,
  \ 'nvim_lsp': v:true,
  \ }
lua << EOF
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn['vsnip#available'](1) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn['vsnip#jumpable'](-1) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
EOF
