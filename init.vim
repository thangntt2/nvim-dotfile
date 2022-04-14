syntax enable
set guifont=Hack\ Nerd\ Font\ Mono:h13
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
" let clip = resolve(exepath('clip.exe'))
" let g:clipboard = {
"   \ 'name': 'clip',
"   \ 'copy': {
"   \ '+': clip,
"   \ '*': clip
"   \   },
"   \ 'paste': {
"   \ '+': 'pbpaste.exe --lf',
"   \ '*': 'pbpaste.exe --lf'
"   \   }
"   \ }

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
Plug 'arcticicestudio/nord-vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'rmagatti/auto-session'
" Git
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'
Plug 'sodapopcan/vim-twiggy', { 'on': 'Twiggy' }    " git branch manager
Plug 'jiangmiao/auto-pairs'
" Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'NTBBloodbath/rest.nvim'

" LSP specific block
Plug 'neovim/nvim-lspconfig'
" Plug 'glepnir/lspsaga.nvim'
Plug 'tami5/lspsaga.nvim'
Plug 'stevearc/aerial.nvim'
Plug 'ms-jpq/coq_nvim'

" Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
Plug 'ray-x/lsp_signature.nvim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install'
  \ }
" Debug
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'gfanto/fzf-lsp.nvim'

call plug#end()

colorscheme gruvbox

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

" preview definition
nnoremap <silent>gd <Cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent>gD <cmd>lua require'lspsaga.provider'.preview_definition()<CR>

" rename
nnoremap <leader>gr <cmd>lua require'lspsaga.provider'.rename()<CR>

" show
nnoremap <silent><leader>cd <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>

" jump diagnostic
nnoremap <silent>gj <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
nnoremap <silent>gk <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>
nnoremap <silent>go <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>

let g:coq_settings = { 'auto_start': 'shut-up', "keymap.recommended": v:true }

lua << EOF
  coq = require("coq")
  -- Setup lspconfig.
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

  local aerial = require("aerial")
  aerial.setup({})

  lspconfig.rust_analyzer.setup{coq.lsp_ensure_capabilities{
      capabilities = lsp_status.capabilities,
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
  }}

  local pid = vim.fn.getpid()
  local omnisharp_bin = "~/Workspace/omnisharp-lsp/OmniSharp"
  lspconfig.omnisharp.setup{coq.lsp_ensure_capabilities{
      cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) },
      capabilities = lsp_status.capabilities
  }}

  lspconfig.tsserver.setup{coq.lsp_ensure_capabilities{
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      capabilities = lsp_status.capabilities,
      lsp_status.on_attach(client, bufnr)
      aerial.on_attach(client, bufnr)

      require "lsp_signature".on_attach(lsp_signature_conf)
    end,
  }}

  local saga = require 'lspsaga'
  saga.init_lsp_saga()
EOF

lua << EOF
require('gitsigns').setup()
EOF

" FZF settings
" command! FZFS call fzf#run(fzf#wrap({'source': 'git ls-files'}))
" nnoremap <silent> <C-space> :Leaderf buffer<CR>
" nnoremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e ")<CR>
nnoremap <silent> <C-P> :call fzf#run(fzf#wrap({'source': 'git ls-files'}))<CR>
nnoremap <silent> <C-space> :Buffers <CR>
nnoremap <silent> <C-W> <cmd>lua vim.lsp.buf.workspace_symbol() <CR>
nnoremap <silent> <C-F> :Rg <CR>
let g:fzf_preview_window = ['down:50%:hidden', 'ctrl-/']

" Aerial settings
nnoremap <silent> <C-]> <cmd>call aerial#fzf()<cr>

" rest.nvim
nnoremap <silent> <C-q> <Plug>RestNvim<CR>

lua << EOF
local dap = require('dap')
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {'server', 'test-debug', os.getenv('HOME') .. '~/.config/nvim/vscode-node-debug2/src/nodeDebug.ts'},
}
dap.configurations.typescript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require'dap.utils'.pick_process,
  },
}
EOF
