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
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-commentary'
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }   " fuzzy file searcher
Plug 'justinmk/vim-sneak'
Plug 'styled-components/vim-styled-components', { 'branch': 'main', 'for': 'typescript.tsx' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'gruvbox-community/gruvbox'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'kshenoy/vim-signature'
Plug 'arcticicestudio/nord-vim'
Plug 'nvim-lua/plenary.nvim'
" Git
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'
Plug 'sodapopcan/vim-twiggy', { 'on': 'Twiggy' }    " git branch manager

" LSP specific block
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'p00f/nvim-ts-rainbow'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'],
  \ }
call plug#end()

colorscheme nord

" Prettier
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0

" vim-sneak settings
let g:sneak#label = 1
let g:sneak#s_next = 1

" LeaderF settings
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
nnoremap <silent> <C-space> :Leaderf buffer<CR>
nnoremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e ")<CR>
nnoremap <silent> <C-P> :LeaderfFile<CR>

function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

" Lightline settings
let g:lightline = {
  \ 'colorscheme': 'nord',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitbranch', 'lsp', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'FugitiveStatusline',
  \   'lsp': 'LspStatus',
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

" bufferline
lua << EOF
require("bufferline").setup{}
EOF

" LSP 
lua << EOF
lspconfig = require'lspconfig'

local lsp_status = require('lsp-status')
lsp_status.register_progress()

lspconfig.tsserver.setup{
  on_attach = lsp_status.on_attach,
  capabilities = lsp_status.capabilities
}

local saga = require 'lspsaga'
saga.init_lsp_saga()
EOF

" Organize import

nnoremap <silent><leader>og <cmd>lua vim.lsp.buf.execute_command({command = "_typescript.organizeImports", arguments = {vim.fn.expand("%:p")}})<CR>

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
nnoremap <silent>gr <cmd>lua vim.lsp.buf.references()<CR>
" close rename win use <C-c> in insert mode or `q` in noremal mode or `:q`

" preview definition
nnoremap <silent>gd <Cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent>gD :Lspsaga preview_definition <CR>

" Lsp auto completion
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

lua << EOF
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
  };
}
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

autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  " Define mappings
  nnoremap <silent><buffer><expr> <CR>
  \ defx#do_action('open')
  nnoremap <silent><buffer><expr> c
  \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
  \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
  \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> l
  \ defx#do_action('open')
  nnoremap <silent><buffer><expr> E
  \ defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> P
  \ defx#do_action('preview')
  nnoremap <silent><buffer><expr> o
  \ defx#do_action('open_tree', 'toggle')
  nnoremap <silent><buffer><expr> K
  \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
  \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M
  \ defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> C
  \ defx#do_action('toggle_columns',
  \                'mark:indent:icon:filename:type:size:time')
  nnoremap <silent><buffer><expr> S
  \ defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> d
  \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
  \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> !
  \ defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x
  \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
  \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
  \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ;
  \ defx#do_action('repeat')
  nnoremap <silent><buffer><expr> -
  \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
  \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
  \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
  \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
  \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j
  \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
  \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-r>
  \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
  \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
  \ defx#do_action('change_vim_cwd')
endfunction

nnoremap <silent> - :Defx `escape(expand('%:p:h'), ' :')` -search=`expand('%:p')`<CR>

autocmd BufEnter,VimEnter,BufNew,BufWinEnter,BufRead,BufCreate
      \ * if isdirectory(expand('<amatch>'))
      \   | call s:browse_check(expand('<amatch>')) | endif

function! s:browse_check(path) abort
  if bufnr('%') != expand('<abuf>')
    return
  endif

  " Disable netrw.
augroup FileExplorer
  autocmd!
augroup END

execute 'Defx' a:path
endfunction

call defx#custom#column('icon', {
      \ 'directory_icon': '▸',
      \ 'opened_icon': '▾',
      \ 'root_icon': ' ',
      \ })

lua << EOF
require('gitsigns').setup()
EOF
