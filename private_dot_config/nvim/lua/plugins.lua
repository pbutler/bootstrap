return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'Shougo/neoyank.vim'
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path'
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup {
        mapping = {
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
        },
        sources = {
          { name = 'buffer' },
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'path' },
        },
      }
    end
  }

  use { 'ray-x/lsp_signature.nvim',
    config = function()
      require'lsp_signature'.setup {
        bind = true,
        doc_lines = 5,
        floating_window = true,
        hint_enable = false,
        handler_opts = {border = "single"},
        extra_trigger_chars = {"(", ","},
      }
    end
  }
  use 'SirVer/ultisnips'
  use 'honza/vim-snippets.git'

  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup()
    end
  }
  use 'folke/lsp-colors.nvim'


  -- Colors
  use 'ishan9299/nvim-solarized-lua'
  use 'glepnir/zephyr-nvim'

  -- file explorer
  use 'Shougo/defx.nvim'
  use 'kristijanhusak/defx-icons'
  use 'kristijanhusak/defx-git'
 
  use 'schickling/vim-bufonly'
  use 'ntpeters/vim-better-whitespace'
  use 'nathanaelkane/vim-indent-guides'
 
  -- telesecope
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require('configs.telescope')
    end
  }
  use 'nvim-lua/popup.nvim'
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
  use {'nvim-treesitter/nvim-treesitter', 
    config = function()
      require'nvim-treesitter.configs'.setup {
        highlight = { enable = true },
      }
    end,
    run = ':TSUpdate'}

  use 'kabouzeid/nvim-lspinstall'

  use {
    'neovim/nvim-lspconfig',
    config = function()
      require('configs.lsp').setup()
    end
  }

  use({
    'jose-elias-alvarez/null-ls.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      require('configs.null-ls')
      require('lspconfig')['null-ls'].setup({
        on_attach = require('configs.lsp').on_attach,
      })
    end,
  })

  -- call dein#add('glepnir/lspsaga.nvim')
 

  use 'Konfekt/FastFold'
  -- call dein#add('sjl/gundo.vim')
 
  -- git
  use 'tpope/vim-fugitive'
  use 'gregsexton/gitv'
  use 'knsh14/vim-github-link'
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup()
    end
  }
  use 'idanarye/vim-merginal'
 
  -- lightline
  use 'josa42/nvim-lightline-lsp'
  use 'itchyny/lightline.vim'
  use 'mgee/lightline-bufferline'
 
 
  use 'sheerun/vim-polyglot'
  use 'majutsushi/tagbar'
  use {
    'b3nj5m1n/kommentary',
    config = function()
      require('kommentary.config').configure_language(
        'default',
        { prefer_single_line_comments = true }
      )
    end
  }
 
  -- python
  use {'jmcantrell/vim-virtualenv', ft = {'python'}}
  use 'tmhedberg/SimpylFold'
  use {'kkoomen/vim-doge', run = ':call doge#install({"headless": 1})'}
 
 
  use {'pangloss/vim-javascript', ft = {'javascript.jsx'}}
 
  use 'ryanoasis/vim-devicons'
 
  use 'lervag/vimtex'
  use 'lervag/wiki.vim'
  use 'lervag/wiki-ft.vim'
end)
