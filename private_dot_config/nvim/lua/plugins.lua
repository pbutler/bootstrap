return require('packer').startup(function(use)
  use 'dstein64/vim-startuptime'
  use 'wbthomason/packer.nvim'
  use 'Shougo/neoyank.vim'

   use({
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup()
    end,
  })


  use('machakann/vim-sandwich')

  use({
    'ggandor/lightspeed.nvim',
    requires = {
      'tpope/vim-repeat',
    },
  })

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      require("configs.nvim-cmp")
    end
  }

  use({
      'L3MON4D3/LuaSnip',
      config = function()
        require("configs.luasnip")
      end,
      requires = {
        --'honza/vim-snippets',
        'rafamadriz/friendly-snippets',
      },
    })

  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup()
    end
  }
  use 'folke/lsp-colors.nvim'


  -- Colors
  use({
      "catppuccin/nvim",
      as = "catppuccin",
      config = function ()
        vim.g.catppuccin_flavour = "macchiato"
        require('configs.catppuccin')
        vim.cmd[[colorscheme catppuccin]]
      end
    })

  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function ()
      vim.opt.termguicolors = true
      vim.cmd [[highlight IndentBlanklineIndent1 guibg=#1E3D49 gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent2 guibg=#0E2D39 gui=nocombine]]

      require("indent_blankline").setup({
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
      })
    end
  }

  -- file explorer
  use 'Shougo/defx.nvim'
  use 'kristijanhusak/defx-icons'
  use 'kristijanhusak/defx-git'

  use 'schickling/vim-bufonly'
  use 'ntpeters/vim-better-whitespace'

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
      require('configs.telescope').setup()
    end
  }

  use 'nvim-lua/popup.nvim'

  use {'nvim-treesitter/nvim-treesitter',
    config = function()
      require'nvim-treesitter.configs'.setup {
        highlight = { enable = true },
      }
    end,
    run = ':TSUpdate'
  }


  use {"williamboman/mason.nvim",
    config = function()
      require("mason").setup({
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗"
            }
          }
        })
    end,
  }

  -- LSP

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


  use {
    'williamboman/mason-lspconfig.nvim',
    requires = {
      'neovim/nvim-lspconfig',
    },
    config = function()
      require("mason-lspconfig").setup({
          automatic_installation = true,
        })
      require("configs.lsp").setup()
    end,
    requires = {

    }
  }

  use({
    'jose-elias-alvarez/null-ls.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      require('configs.null-ls')
      --require('lspconfig')['null-ls'].setup({
      --   on_attach = require('configs.lsp').on_attach,
      -- })
    end,
  })


use({
    'weilbith/nvim-code-action-menu',
    requires = {
      'neovim/nvim-lspconfig',
    },
    cmd = 'CodeActionMenu',
  })
  -- call dein#add('glepnir/lspsaga.nvim')
  use('RRethy/vim-illuminate')

  use 'Konfekt/FastFold'
  use 'simnalamburt/vim-mundo'

  -- git
  use 'tpope/vim-fugitive'
  use 'knsh14/vim-github-link'
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('configs.gitsigns').setup()
    end
  }
  use 'idanarye/vim-merginal'

use {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig",
    config = function()
    end
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
  use({
      'simrat39/symbols-outline.nvim',
      requires = {
        'neovim/nvim-lspconfig',
      },
      cmd = {
        'SymbolsOutline',
        'SymbolsOutlineOpen',
        'SymbolsOutlineClose',
      },
    })
  use {
    'b3nj5m1n/kommentary',
    config = function()
      require('kommentary.config').configure_language(
        'default',
        { prefer_single_line_comments = true }
      )
    end
  }

  use {
    "danymat/neogen",
    config = function()
      require('neogen').setup {
        enabled = true,
        languages = {
          python = {
            template = {
              annotation_convention = "reST"
            }
          }
        }
      }
      local opts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap("n",
        "<Leader>n",
        ":lua require('neogen').generate()<CR>", opts)
    end,
    requires = "nvim-treesitter/nvim-treesitter"
  }

  -- python
  use {'jmcantrell/vim-virtualenv', ft = {'python'}}
  use 'tmhedberg/SimpylFold'

  use {'pangloss/vim-javascript', ft = {'javascript.jsx'}}

  use 'ryanoasis/vim-devicons'

  use {'nvim-orgmode/orgmode',
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      require('orgmode').setup_ts_grammar()

      require'nvim-treesitter.configs'.setup {
        -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
        highlight = {
          enable = true,
          -- disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
          additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
        },
        ensure_installed = {'org'}, -- Or run :TSUpdate org
      }
      require('orgmode').setup{
        org_agenda_files = "~/org/*",
        -- org_agenda_files = "~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/*",
        org_default_notes_file = "~/org/inbox.org",
        org_todo_keywords = {'TODO(t)', 'WAITING(w)', '|', 'DONE(d)', 'DELEGATED(D)'},
        org_agenda_templates = {
          -- T = { description = 'Todo', template = '* TODO %?\n %u', target = '~/org/todo.org' },
          j = { description = 'Journal',
                template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
                target = '~/sync/org/journal.org' },
        },
      }

      local opts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap("n",
        "<Leader>ooo",
        ":edit ~/org/inbox.org<CR>", opts)
    end
  }

--  use {
--    "nvim-neorg/neorg",
--    config = function()
--      local neorg_callbacks = require('neorg.callbacks')
--      require('neorg').setup {
--        load = {
--          ["core.defaults"] = {},
--          ["core.norg.dirman"] = {
--            config = {
--              workspaces = {
--                work = "~/norg/work",
--                home = "~/norg/home",
--              }
--            },
--          },
--          ["core.norg.completion"] = {
--            config = {
--              engine = "nvim-cmp"
--            }
--          },
--          ["core.norg.journal"] = {},
--          ["core.norg.qol.toc"] = {},
--          ["core.gtd.base"] = {
--            config = {
--              workspace = "work",
--              -- workspace = "test",
--              -- exclude = { "gtd.norg", "neogen.norg", "kenaos.norg", "neorg.norg", "Praline&Pandas.norg" },
--              -- custom_tag_completion = true,
--            },
--          },
--          ["core.keybinds"] = {
--            config = {
--              default_keybinds = true,
--              neorg_leader = "<leader>o",
--            },
--          },
--          ["core.norg.concealer"] = {
--            config = {
--              icon_preset = "diamond",
--            },
--          },
--        },
--      }
--    end,
--    requires = "nvim-lua/plenary.nvim"
--  }

  use 'lervag/vimtex'
  use 'lervag/wiki.vim'
  use 'lervag/wiki-ft.vim'
end)
