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
" LSP specific block
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'arcticicestudio/nord-vim'
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'gruvbox-community/gruvbox'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'kshenoy/vim-signature'
call plug#end()

colorscheme nord

" " " Better typescript highlighting
" autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
" autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" CoC settings
command! -nargs=0 Prettier :CocCommand prettier.formatFile
au BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx
lua require("bufferline").setup{}

let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ ]

autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier
nnoremap <silent> <Leader>p :Prettier<CR>
" Remap for rename current word
nnoremap <silent> <leader>rn <Plug>(coc-rename)
" remap go definition
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
" autoimport vars
inoremap <silent><expr> <cr> 
      \ pumvisible() ? coc#_select_confirm() : 
      \ "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Completion with <TAB>
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
let g:coc_snippet_next = '<cr>'
" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
nnoremap <silent> <leader>or :OR<cr>
" use <leader>d to show list of diagnostics
nnoremap <silent> <leader>d :<C-u>CocList diagnostics<cr>
" call coc code action
nmap <leader>do <Plug>(coc-codeaction)
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
" end of Coc settings

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
  \             [ 'gitbranch', 'cocstatus', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveHead',
  \   'cocstatus': 'coc#status'
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
