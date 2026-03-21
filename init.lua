local vim = vim
--
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('i', 'jj', '<esc>')

if vim.lsp and vim.lsp.util and vim.lsp.util.show_document then
  vim.lsp.util.jump_to_location = function(location, position_encoding, reuse_win)
    return vim.lsp.util.show_document(location, position_encoding, {
      focus = true,
      reuse_win = reuse_win,
    })
  end
end

vim.o.hidden = true
vim.o.switchbuf = 'usetab,newtab'
vim.o.termguicolors = true
vim.o.rnu = true
vim.o.updatetime = 300
vim.o.timeoutlen = 300
vim.o.expandtab = true
vim.o.clipboard = 'unnamedplus'
vim.o.swapfile = false
vim.o.signcolumn = 'yes'
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.showmode = false
vim.o.showtabline = 2
vim.o.completeopt = "menuone,noselect"
vim.o.mouse = 'a'

-- set tab numbers
-- vim.o.guitablabel = "%N:%M%t"

-- Disable old vi style
vim.o.compatible = false

-- Don't pass messages to |ins-completion-menu|.
vim.o.shortmess = 'c'

-- Indentation
vim.o.autoindent = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2

vim.o.syntax = 'on'

vim.wo.number = true
vim.api.nvim_command('filetype indent on')
vim.api.nvim_command('filetype plugin on')

vim.o.showmatch = true
vim.o.hlsearch = true
vim.o.autochdir = false

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Spell checking
vim.opt.spelllang = 'en_us'
vim.opt.spell = true
vim.opt.spelloptions = 'camel'

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  {
    'tpope/vim-fugitive',
    dependencies = {
      'tommcdo/vim-fubitive'
    }
  },
  'tpope/vim-rhubarb',
  'dstein64/vim-startuptime',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    opts = {}
  },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },
  {
    'mfussenegger/nvim-lint',
    config = function()
      require('lint').linters_by_ft = {
        javascript = { 'eslint' },
        typescript = { 'eslint' },
        javascriptreact = { 'eslint' },
        typescriptreact = { 'eslint' },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end
  },
  {
    "ggandor/leap.nvim",
    config = function ()
      vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward)', { desc = 'Leap forward' })
      vim.keymap.set({ 'n', 'x', 'o' }, 'gS', '<Plug>(leap-backward)', { desc = 'Leap backward' })
      vim.keymap.set({ 'n', 'x', 'o' }, 'gs', '<Plug>(leap-from-window)', { desc = 'Leap from window' })
    end
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      settings = {
        tsserver_plugins = { "@styled/typescript-styled-plugin" },
        tsserver_locale = "en",
      },
    }
  },
  { 'akinsho/toggleterm.nvim', version = "*", config = true },
  {
    "michaelb/sniprun",
    branch = "master",

    build = "sh install.sh",
    -- do 'sh install.sh 1' if you want to force compile locally
    -- (instead of fetching a binary from the github release). Requires Rust >= 1.65

    config = function()
      require("sniprun").setup({
      -- your options
      })
    end,
  },
  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',    opts = {} },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },


  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'gruvbox',
        component_separators = '|',
        section_separators = '',
      },
    },
  },
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },
  {
    'ojroques/vim-oscyank',
    branch = "main",
    config = function()
      -- Should be accompanied by a setting clipboard in tmux.conf, also see
      -- https://github.com/ojroques/vim-oscyank#the-plugin-does-not-work-with-tmux
      vim.g.oscyank_term = "default"
      vim.g.oscyank_max_length = 0 -- unlimited
      -- Below autocmd is for copying to OSC52 for any yank operation,
      -- see https://github.com/ojroques/vim-oscyank#copying-from-a-register
      vim.api.nvim_create_autocmd("TextYankPost", {
        pattern = "*",
        callback = function()
          if vim.v.event.operator == "y" and vim.v.event.regname == "" then
            vim.cmd('OSCYankRegister "')
          end
        end,
      })
    end,
  },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  'jparise/vim-graphql',
  'tpope/vim-vinegar',
  {
    'akinsho/nvim-bufferline.lua',
    opts = {}
  },
  {
    'styled-components/vim-styled-components',
    branch = 'main',
  },
  {
    'stevearc/conform.nvim',
    config = function()
      local conform = require('conform')

      conform.setup({
        formatters_by_ft = {
          javascript = { 'prettier' },
          typescript = { 'prettier' },
          javascriptreact = { 'prettier' },
          typescriptreact = { 'prettier' },
          python = { 'ruff_format' },
        },
        format_on_save = {
          lsp_format = 'fallback',
          timeout_ms = 500,
        },
      })

      vim.api.nvim_create_user_command('FormatWrite', function()
        conform.format({ async = false, lsp_format = 'fallback' })
      end, { desc = 'Format current buffer and write changes' })

      vim.api.nvim_create_user_command('Format', function()
        conform.format({ async = true, lsp_format = 'fallback' })
      end, { desc = 'Format current buffer' })
    end
  },
  {
    'rmagatti/auto-session',
    opts = function()
      return {
        log_level = "error",

        cwd_change_handling = {
          restore_upcoming_session = true,   -- already the default, no need to specify like this, only here as an example
          pre_cwd_changed_hook = nil,        -- already the default, no need to specify like this, only here as an example
          post_cwd_changed_hook = function() -- example refreshing the lualine status line _after_ the cwd changes
            require("lualine").refresh()     -- refresh lualine so the new session name is displayed in the status bar
          end,
        },
      }
    end
  },
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets' },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = 'enter' },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = { documentation = { auto_show = false, } },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },
  {
    'ray-x/lsp_signature.nvim',
    opts = function()
      return {
        bind = true,   -- This is mandatory, otherwise border config won't get registered.
        doc_lines = 2, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
        -- set to 0 if you DO NOT want any API comments be shown
        -- This setting only take effect in insert mode, it does not affect signature help in normal
        -- mode, 10 by default

        floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
        fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
        hint_enable = true, -- virtual hint enable
        hint_prefix = "🐼 ", -- Panda for parameter
        hint_scheme = "String",
        hi_parameter = "Search", -- how your parameter will be highlight
        max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
        -- to view the hiding contents
        max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
        handler_opts = {
          border = "double", -- double, single, shadow, none
        },
        extra_trigger_chars = {}
      }
    end,
  },
  {
    "folke/trouble.nvim",
    opts = {
      focus = true,
      follow = true,
      modes = {
        preview_float = {
          mode = "diagnostics",
          preview = {
            type = "float",
            relative = "editor",
            border = "rounded",
            title = "Preview",
            title_pos = "center",
            position = { 0, -2 },
            size = { width = 0.3, height = 0.3 },
            zindex = 200,
          },
        },
      }
    }, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    },
    config = function()
      local gwidth = vim.api.nvim_list_uis()[1].width
      local gheight = vim.api.nvim_list_uis()[1].height
      local width = 80
      local height = 40
      require("nvim-tree").setup({
        actions = {
          open_file = {
            quit_on_open = true
          },
        },
        update_focused_file = {
          enable = true,
          update_root = false,
        },
        disable_netrw = true,
        hijack_netrw = true,
        respect_buf_cwd = false,
        sync_root_with_cwd = true,
        view = {
          relativenumber = true,
          float = {
            enable = true,
            open_win_config = {
              relative = "editor",
              width = width,
              height = height,
              row = (gheight - height) * 0.4,
              col = (gwidth - width) * 0.5,
            }
          },
        },
      })
    end,
    on_attach = function(bufnr)
      local api = require "nvim-tree.api"

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      -- api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
    end
  },
  ---@type LazySpec
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "<leader>-",
        "<cmd>silent Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        -- Open in the current working directory
        "<leader>cw",
        "<cmd>silent Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory" ,
      },
      {
        -- NOTE: this requires a version of yazi that includes
        -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
        '<c-up>',
        "<cmd>silent Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    ---@type YaziConfig
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      keymaps = {
        show_help = '<f1>',
      },
    }
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    'lewis6991/hover.nvim',
    config = function ()
      require('hover').config({
        --- List of modules names to load as providers.
        --- @type (string|Hover.Config.Provider)[]
        providers = {
          'hover.providers.diagnostic',
          'hover.providers.lsp',
          'hover.providers.dap',
          'hover.providers.man',
          'hover.providers.dictionary',
          -- Optional, disabled by default:
          -- 'hover.providers.gh',
          -- 'hover.providers.gh_user',
          -- 'hover.providers.jira',
          -- 'hover.providers.fold_preview',
          -- 'hover.providers.highlight',
        },
        preview_opts = {
          border = 'single'
        },
        -- Whether the contents of a currently open hover window should be moved
        -- to a :h preview-window when pressing the hover keymap.
        preview_window = false,
        title = true,
        mouse_providers = {
          'hover.providers.lsp',
        },
        mouse_delay = 1000
      })
    end
  },
})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == 'ruff' then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
    on_attach(args)
  end,
  desc = 'LSP: Disable hover capability from Ruff',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local telescope_actions = require('telescope.actions')
require('telescope').setup {
  defaults = {
    layout_config = {
      horizontal = { width = 0.7 },
      -- other layout configuration here
    },
    find_files = {
      theme = "dropdown",
    },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ['<C-j>'] = telescope_actions.move_selection_next,
        ['<C-k>'] = telescope_actions.move_selection_previous,
        ['<Down>'] = telescope_actions.toggle_selection + telescope_actions.move_selection_next,

        ['<Up>'] = telescope_actions.move_selection_previous + telescope_actions.toggle_selection
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'http', 'css', 'scala', 'java' },
  sync_install = true,
  modules = {},
  ignore_install = { 'json' },
  disable = { 'json' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  -- incremental_selection = {
  --   enable = true,
  --   keymaps = {
  --     init_selection = '<c-space>',
  --     node_incremental = '<c-space>',
  --     scope_incremental = '<c-s>',
  --     node_decremental = '<M-space>',
  --   },
  -- },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>gj', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '<leader>gk', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
on_attach = function(args)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local bufnr = args.buf
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gh', function ()
    require('telescope.builtin').lsp_references({ layout_strategy = 'vertical' })
  end, '[G]oto [H]Incoming calls')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  nmap('<leader>ca', vim.lsp.buf.code_action, "LSP: Code Action")

  -- See `:help K` for why this keymap
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('<leader>cd', function() 
    require('trouble').open({
      mode = "diagnostics",
      win = { type = "float" },
      follow = true
    })
  end,'Trouble')

  -- Lesser used LSP functionality
  -- nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

vim.lsp.config('ruff', {
  on_attach = function(client, bufnr)
    -- Optional: Disable hoverProvider if using Pyright alongside Ruff
    client.server_capabilities.hoverProvider = false
  end,
  init_options = {
    settings = {
      format = { enable = true }, -- Enable formatting with Ruff
      lint = { enable = true },   -- Enable linting with Ruff
      args = { '--line-length', '120' }, -- Example of passing CLI arguments
    },
  }
})

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  automatic_installation = false
}

vim.cmd [[colorscheme gruvbox]]
vim.cmd([[ command! -nargs=1 Browse silent exec '!open "<args>"' ]])

-- key maps
--
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<Tab>', '<cmd>bnext<CR>', { silent = true })
vim.keymap.set('n', '<S-Tab>', '<cmd>bprevious<CR>', { silent = true })
vim.keymap.set('n', '<M-j>', '<C-W>j', { silent = true })
vim.keymap.set('n', '<M-k>', '<C-W>k', { silent = true })
vim.keymap.set('n', '<M-h>', '<C-W>h', { silent = true })
vim.keymap.set('n', '<M-l>', '<C-W>l', { silent = true })
vim.keymap.set('n', '<C-j>', '<C-e>', { silent = true })
vim.keymap.set('n', '<C-k>', '<C-y>', { silent = true })
vim.keymap.set('n', '<C-l>', 'zl', { silent = true })
vim.keymap.set('n', '<C-h>', 'zh', { silent = true })
vim.keymap.set('n', '<leader>p', '<cmd>Format<CR>', { silent = true })
vim.keymap.set('n', '<leader>P', '<cmd>FormatWrite<CR>', { silent = true })
vim.keymap.set('n', '<leader>or', '<cmd>TSToolsOrganizeImports<CR>', { silent = true })
vim.keymap.set('n', '<C-t>', '<Cmd>exe v:count1 . "ToggleTerm"<CR>', { silent = true })
vim.keymap.set('i', '<C-t>', '<Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>', { silent = true })
vim.keymap.set('n', '-', '<Cmd>NvimTreeFindFile<CR>', { silent = true })

vim.keymap.set('n', '<C-p>', function()
  builtin.git_files({ layout_strategy = 'vertical' })
end, { noremap = true, silent = true })
vim.keymap.set('n', '<C-space>',
  function() builtin.buffers({ layout_strategy = 'vertical', ignore_current_buffer = true, sort_mru = true }) end,
  { noremap = true, silent = true })
vim.keymap.set('n', '<C-F>', function() builtin.live_grep({ layout_strategy = 'vertical' }) end,
  { noremap = true, silent = true })
-- let g:fzf_preview_window = ['down:50%:hidden', 'ctrl-/']
