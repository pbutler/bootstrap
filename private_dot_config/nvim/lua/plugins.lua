return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'Shougo/neoyank.vim'

   use({
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup()
    end,
  })
  use('machakann/vim-sandwich')

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'quangnguyen30192/cmp-nvim-ultisnips',
    },
    config = function()
      require("configs.nvim-cmp")
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
  use { "SirVer/ultisnips",
    requires = "honza/vim-snippets",
    config = function()
      vim.g.UltiSnipsRemoveSelectModeMappings = 0
    end,
  }

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

--  use {
--    'shaunsingh/nord.nvim',
--    config = function ()
--      vim.g.nord_contrast = true
--      vim.g.nord_borders = true
--      vim.g.nord_disable_background = false
--      vim.g.nord_italic = false
--      require('nord').set()
--    end
--  }
--


use({
	"catppuccin/nvim",
	as = "catppuccin",
  config = function ()
    vim.cmd[[colorscheme catppuccin]]
  end
})


  -- file explorer
  use 'Shougo/defx.nvim'
  use 'kristijanhusak/defx-icons'
  use 'kristijanhusak/defx-git'

  use 'schickling/vim-bufonly'
  use 'ntpeters/vim-better-whitespace'
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function ()
      vim.opt.termguicolors = true
      vim.cmd [[highlight IndentBlanklineIndent1 guibg=#2E3440 gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent2 guibg=#4C566A gui=nocombine]]

      require("indent_blankline").setup {
        char = " ",
        char_highlight_list = {
          "IndentBlanklineIndent1",
          "IndentBlanklineIndent2",
        },
        space_char_highlight_list = {
          "IndentBlanklineIndent1",
          "IndentBlanklineIndent2",
        },
        show_trailing_blankline_indent = false,
      }
    end
  }
  -- telescope
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'nvim-telescope/telescope-fzf-native.nvim'
    },
    config = function()
      require('configs.telescope')
    end
  }
  use 'nvim-lua/popup.nvim'
  use {'nvim-treesitter/nvim-treesitter',
    config = function()
      require'nvim-treesitter.configs'.setup {
        highlight = { enable = true },
      }
    end,
    run = ':TSUpdate'}

use {
    'williamboman/nvim-lsp-installer',
    config = function ()
      local lsp_installer = require("nvim-lsp-installer")

      -- Register a handler that will be called for all installed servers.
      -- Alternatively, you may also register handlers on specific server instances instead (see example below).
      lsp_installer.on_server_ready(function(server)
        local opts = {}

      -- (optional) Customize the options passed to the server
      -- if server.name == "tsserver" then
      --     opts.root_dir = function() ... end
      -- end

      -- This setup() function is exactly the same as lspconfig's setup function.
      -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
        server:setup(opts)
      end)
    end
}
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
  use('RRethy/vim-illuminate')

  use 'Konfekt/FastFold'
  use 'simnalamburt/vim-mundo'

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


  use {"SmiteshP/nvim-gps",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-gps").setup()
    end
  }
  use {
    'kdheepak/tabline.nvim',
    config = function()
      require'tabline'.setup {enable = false}
    end,
    requires = {'hoob3rt/lualine.nvim', 'kyazdani42/nvim-web-devicons'}
  }

  use {
      'hoob3rt/lualine.nvim',
    -- your statusline
    config = function() require('configs.lualine') end,
    -- some optional icons
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }


  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({
          '*',
          '!packer',
        }, {
          names = false,
        })
    end,
  }

  use 'andymass/vim-matchup'
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
