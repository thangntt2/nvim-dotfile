syntax enable
set guifont=Hack\ Nerd\ Font:h13
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
set mouse=a

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

set rtp+=/usr/bin/fzf

" improve clipboard speed
let clip = resolve(exepath('clip.exe'))
let g:clipboard = {
  \ 'name': 'clip',
  \ 'copy': {
  \ '+': clip,
  \ '*': clip
  \   },
  \ 'paste': {
  \ '+': 'pbpaste.exe --lf',
  \ '*': 'pbpaste.exe --lf'
  \   }
  \ }

nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" Consistent movement
nnoremap <A-j> <C-W>j
nnoremap <A-k> <C-W>k
nnoremap <A-h> <C-W>h
nnoremap <A-l> <C-W>l

nnoremap <c-j> <c-e>
nnoremap <c-k> <c-y>
nnoremap <c-l> zl
nnoremap <c-h> zh

"netrw config
" let g:netrw_banner = 0
" let g:netrw_liststyle = 3
" let g:netrw_altv = 1
" let g:netrw_winsize = 25
autocmd FileType netrw setl bufhidden=wipe
let g:netrw_fastbrowse = 0
let g:netrw_browse_split = 0

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
Plug 'tpope/vim-vinegar'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-commentary'
Plug 'justinmk/vim-sneak'
Plug 'styled-components/vim-styled-components', { 'branch': 'main', 'for': 'typescript.tsx' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'gruvbox-community/gruvbox'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'kshenoy/vim-signature'
Plug 'arcticicestudio/nord-vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'rmagatti/auto-session'
Plug 'voldikss/vim-floaterm'
" Git
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'
Plug 'sodapopcan/vim-twiggy', { 'on': 'Twiggy' }    " git branch manager
Plug 'jiangmiao/auto-pairs'
" Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ojroques/nvim-lspfuzzy'

" LSP specific block
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
Plug 'liuchengxu/vista.vim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install'
  \ }
call plug#end()

colorscheme nord

" Prettier
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let g:prettier#config#arrow_parens = 'avoid'

" vim-sneak settings
let g:sneak#label = 1
let g:sneak#s_next = 1

" " LeaderF settings
" let g:Lf_WindowPosition = 'popup'
" let g:Lf_PreviewInPopup = 1
" let g:Lf_ShowDevIcons = 1
" nnoremap <silent> <C-space> :Leaderf buffer<CR>
" nnoremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e ")<CR>
" nnoremap <silent> <C-P> :LeaderfFile<CR>

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

" bufferline
lua << EOF
require("bufferline").setup{}
EOF

" LSP 
lua << EOF
lspconfig = require'lspconfig'

local lsp_status = require('lsp-status')
lsp_status.register_progress()

lsp_signature_conf = {
  bind = false, -- This is mandatory, otherwise border config won't get registered.
               -- If you want to hook lspsaga or other signature handler, pls set to false
  doc_lines = 2, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
                 -- set to 0 if you DO NOT want any API comments be shown
                 -- This setting only take effect in insert mode, it does not affect signature help in normal
                 -- mode, 10 by default

  floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
  fix_pos = false,  -- set to true, the floating window will not auto-close until finish all parameters
  hint_enable = true, -- virtual hint enable
  hint_prefix = "🐼 ",  -- Panda for parameter
  hint_scheme = "String",
  use_lspsaga = true,  -- set to true if you want to use lspsaga popup
  hi_parameter = "Search", -- how your parameter will be highlight
  max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
                   -- to view the hiding contents
  max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
  handler_opts = {
    border = "shadow"   -- double, single, shadow, none
  },
  extra_trigger_chars = {}
}

lspconfig.rust_analyzer.setup{
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
}

lspconfig.tsserver.setup{
  on_attach = function(client, bufnr)
    lsp_status.on_attach(client, bufnr)

    local ts_utils = require("nvim-lsp-ts-utils")

    -- defaults
    ts_utils.setup {
        debug = false,
        disable_commands = false,
        enable_import_on_completion = true,

        -- import all
        import_all_timeout = 5000, -- ms
        import_all_priorities = {
            buffers = 4, -- loaded buffer names
            buffer_content = 3, -- loaded buffer content
            local_files = 5, -- git files or files with relative path markers
            same_file = 1, -- add to existing import statement
        },
        import_all_scan_buffers = 100,
        import_all_select_source = false,

        -- eslint
        eslint_enable_code_actions = true,
        eslint_enable_disable_comments = true,
        eslint_bin = "eslint",
        eslint_config_fallback = nil,
        eslint_enable_diagnostics = false,

        -- formatting
        enable_formatting = true,
        formatter = "prettier",
        formatter_config_fallback = nil,

        -- update imports on file move
        update_imports_on_move = true,
        require_confirmation_on_move = false,
        watch_dir = nil,
    }

    -- required to fix code action ranges
    ts_utils.setup_client(client)

    require "lsp_signature".on_attach(lsp_signature_conf)
  end,
  capabilities = lsp_status.capabilities
}

local saga = require 'lspsaga'
saga.init_lsp_saga()
EOF

" Organize import

nnoremap <silent><leader>or <cmd>lua vim.lsp.buf.execute_command({command = "_typescript.organizeImports", arguments = {vim.fn.expand("%:p")}})<CR>

" lsp provider to find the cursor word definition and reference
nnoremap <silent> gh <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>

" code action
nnoremap <silent><leader>ca <cmd>lua require('lspsaga.codeaction').code_action()<CR>
vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>

" show hover doc
nnoremap <silent>K <cmd>lua require'lspsaga.hover'.render_hover_doc()<CR>

" show signature help
nnoremap <silent> gs <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>

nnoremap <silent> gr <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>

" preview definition
nnoremap <silent>gd <Cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent>gD <cmd>lua require'lspsaga.provider'.preview_definition()<CR>

" rename
nnoremap <leader>gr <cmd>lua require'lspsaga.provider'.rename()<CR>

" show
nnoremap <silent><leader>cd <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>

" jump diagnostic
nnoremap <silent>[e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
nnoremap <silent>]e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>


" Lsp auto completion
inoremap <silent><expr> <C-Space> compe#complete()
" inoremap <silent><expr> <CR>      compe#confirm('<CR>')
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
  documentation = true;

  source = {
    path = true;
    buffer = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
    emoji = true;
  };
}
vim.api.nvim_set_keymap('i', '<cr>', 'compe#confirm("<cr>")', { expr = true })
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

lua << EOF
require('gitsigns').setup()
EOF

lua << EOF
require('lspfuzzy').setup {}
EOF

" FZF settings
" command! FZFS call fzf#run(fzf#wrap({'source': 'git ls-files'}))
" nnoremap <silent> <C-space> :Leaderf buffer<CR>
" nnoremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e ")<CR>
nnoremap <silent> <C-P> :call fzf#run(fzf#wrap({'source': 'git ls-files'}))<CR>
nnoremap <silent> <C-space> :Buffers <CR>
nnoremap <silent> <C-F> <cmd>lua vim.lsp.buf.workspace_symbol() <CR>
