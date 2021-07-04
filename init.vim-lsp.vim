set hidden
set switchbuf=usetab,newtab
set termguicolors
set rnu
set updatetime=100
set clipboard=unnamedplus
set noswapfile
set signcolumn=yes
set smartcase
set ignorecase
set showtabline=2
syntax on

" Disable old vi style
set nocompatible

" Indentation
set autoindent
set expandtab
set shiftwidth=2
set softtabstop=2

set showmatch           " highlight matching [{()}]
set hlsearch            " highlight matches
set noautochdir         " root as working directory no matter how deep I am
filetype plugin on

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
nnoremap L $
nnoremap H 0

nnoremap <A-j> <C-W>j
nnoremap <A-k> <C-W>k
nnoremap <A-h> <C-W>h
nnoremap <A-l> <C-W>l

nnoremap <c-j> <c-e>
nnoremap <c-k> <c-y>
nnoremap <c-l> zl
nnoremap <c-h> zh

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
" Lsp
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'],
  \ }
call plug#end()

colorscheme gruvbox

" vim-sneak settings
let g:sneak#label = 1
let g:sneak#s_next = 1

" LeaderF settings
let g:Lf_WindowPosition = 'popup'
nnoremap <silent> <C-space> :Leaderf buffer<CR>
nnoremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e ")<CR>
nnoremap <silent> <C-P> :LeaderfFile<CR>

" nvim-lsp setups
lua << EOF
require'nvim_lsp'.tsserver.setup{}
EOF
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
autocmd Filetype typescript,typescriptreact setlocal omnifunc=v:lua.vim.lsp.omnifunc

" " Lsp statusbar
function! LspStatus() abort
  let sl = ''
  let sl.='%#MyStatuslineLSP#E:'
  let sl.='%#MyStatuslineLSPErrors#%{luaeval("vim.lsp.util.buf_diagnostics_count(\"Error\")")}'
  let sl.='%#MyStatuslineLSP# W:'
  let sl.='%#MyStatuslineLSPWarnings#%{luaeval("vim.lsp.util.buf_diagnostics_count(\"Warning\")")}'
  return sl
endfunction
let lspStatus = '%#MyStatuslineLSP#LSP '.LspStatus() " Lightline settings

let g:lightline = {
  \ 'colorscheme': 'gruvbox',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'lsp', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component': {
  \   'lsp': lspStatus
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead',
  \ },
  \ 'tabline': {'left': [['buffers']]},
  \ 'component_expand': {'buffers': 'lightline#bufferline#buffers'},
  \ 'component_type': {'buffers': 'tabsel'}
  \ }

" Twiggy settings
nnoremap <silent> <leader>g :Twiggy<CR>

" Dirvish settings 
let g:loaded_netrwPlugin = 1
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
augroup dirvish_config
  autocmd!
  autocmd FileType dirvish silent! unmap <buffer> <C-p>
augroup END
nnoremap <silent> <C-B> :Vexplore<CR>

" deoplete.vim setups
let g:deoplete#enable_at_startup = 1

" signify
nnoremap <silent> <leader>s :SignifyToggle<CR>

" vim-prettier
" when running at every change you may want to disable quickfix
let g:prettier#quickfix_enabled = 0
autocmd BufWrite *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync
