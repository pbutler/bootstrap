local M = {}


local spec = {
  'dstein64/vim-startuptime',

  -- Colors
  'folke/lsp-colors.nvim',
  {
    "catppuccin/nvim",
    as = "catppuccin",
    config = function ()
      vim.g.catppuccin_flavour = "macchiato"
      require('configs.catppuccin')
      vim.cmd[[colorscheme catppuccin-macchiato]]
    end
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function ()
      vim.cmd [[highlight IndentBlanklineIndent1 guibg=#1E3D49 gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent2 guibg=#0E2D39 gui=nocombine]]
      local highlight = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
      }
      require("ibl").setup({
          indent = {
            highlight = highlight,
            char = "",
          },
          whitespace = {
            highlight = highlight,
            remove_blankline_trail = false,
          },
      })
    end
  },

  'Shougo/neoyank.vim',
  {'ojroques/nvim-osc52',
    config = function()
      local wk = require('which-key')
      wk.register({
          ["<leader>y"] = { require('osc52').copy_operator, "Yank", expr=true, mode="n"},
          ["<leader>yy"] = { '<leader>y_', "Yank this line", noremap=false, mode="n" },
        })
      wk.register({
          y = { require('osc52').copy_visual, 'Yank Visual', }
        }, {
          mode = 'v',
          prefix = '<leader>',
        })
    end,
  },
  {
    'folke/which-key.nvim',
    config = function()
      local wk = require('which-key')
      wk.setup()
      wk.register({
          x = {
            name = 'Trouble',
            x = { '<cmd>TroubleToggle<CR>', 'Trouble list' },
          },
        }, {
          prefix = '<leader>',
        })
    end,
  },

  -- 'machakann/vim-sandwich',

  {
    "ggandor/leap.nvim",
    dependencies = {
      'tpope/vim-repeat',
    },
    config = function()
      require('leap').add_default_mappings()
    end
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
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
  },

  {
    'L3MON4D3/LuaSnip',
    config = function()
      require("configs.luasnip")
    end,
    version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    dependencies = {
      --'honza/vim-snippets',
      'rafamadriz/friendly-snippets',
    },
  },

  {
    "folke/trouble.nvim",
    dependencies = {"kyazdani42/nvim-web-devicons"},
    config = function()
      require("trouble").setup()
    end
  },

  'schickling/vim-bufonly',

  {
    'ntpeters/vim-better-whitespace',
    config = function ()
      require('configs.whitespace').setup()
    end,
  },

  -- telescope
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  },

  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'nvim-telescope/telescope-fzf-native.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
    },
    config = function()
      require('configs.telescope').setup()
    end
  },

  'nvim-lua/popup.nvim',

  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require'nvim-treesitter.configs'.setup {
        highlight = { enable = true },
      }
    end,
    build = ':TSUpdate'
  },


  -- LSP
  {
    "williamboman/mason.nvim",
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
  },

  {
      'lukas-reineke/lsp-format.nvim',
      config = function()
        require('configs.lsp-format')
      end,
  },

  { 'ray-x/lsp_signature.nvim',
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
  },


  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
    },
    config = function()
      require("mason-lspconfig").setup({
          automatic_installation = true,
        })
      require("configs.lsp").setup()
    end,
  },

  {
    'jose-elias-alvarez/null-ls.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      require('configs.null-ls')
    end,
  },


  {
    'weilbith/nvim-code-action-menu',
    requires = {
      'neovim/nvim-lspconfig',
    },
    cmd = 'CodeActionMenu',
  },
  'RRethy/vim-illuminate',

  'Konfekt/FastFold',
  'simnalamburt/vim-mundo',

  -- git
  'tpope/vim-fugitive',
  'knsh14/vim-github-link',
  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('configs.gitsigns').setup()
    end
  },
  'idanarye/vim-merginal',
  { 'akinsho/git-conflict.nvim',
    version = "*",
    config = function ()
      require('git-conflict').setup( {
          default_mappings = true, -- disable buffer local mapping created by this plugin
          default_commands = true, -- disable commands created by this plugin
          disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
          list_opener = 'copen', -- command or function to open the conflicts list
          highlights = { -- They must have background color, otherwise the default color will be used
            incoming = 'DiffAdd',
            current = 'DiffText',
          }
        })
    end
  },

  {
    "SmiteshP/nvim-navic",
    dependencies = {"neovim/nvim-lspconfig"},
  },

  {
    'hoob3rt/lualine.nvim',
    -- your statusline
    config = function() require('configs.lualine').setup() end,
    -- some optional icons
    dependencies = {'kyazdani42/nvim-web-devicons'}
  },


  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({
          '*',
          '!packer',
        }, {
          names = false,
        })
    end,
  },

  --'andymass/vim-matchup',
  'sheerun/vim-polyglot',
  {
    'simrat39/symbols-outline.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    cmd = {
      'SymbolsOutline',
      'SymbolsOutlineOpen',
      'SymbolsOutlineClose',
    },
  },

  {
    'b3nj5m1n/kommentary',
    config = function()
      require('kommentary.config').configure_language(
        'default',
        { prefer_single_line_comments = true }
        )
    end
  },

  {
    "danymat/neogen",
    config = function()
      require('neogen').setup {
        enabled = true,
        snippet_engine = "luasnip",
        languages = {
          python = {
            template = {
              annotation_convention = "reST"
            }
          }
        }
      }
      local wk = require('which-key')
      wk.register({
          f = { "<cmd>Neogen func<CR>", 'Document function'},
          c = { "<cmd>Neogen class<CR>", 'Document class'}
        }, {
          mode = 'n',
	  silent = true,
	  noremap=true,
          prefix = '<leader>n',
        })
    end,
    requires = "nvim-treesitter/nvim-treesitter"
  },

  -- python
  {'jmcantrell/vim-virtualenv', ft = {'python'}},
  'tmhedberg/SimpylFold',

  {'pangloss/vim-javascript', ft = {'javascript.jsx'}},

  'ryanoasis/vim-devicons',

  -- {'nvim-orgmode/orgmode',
  --   requires = "nvim-treesitter/nvim-treesitter",
  --   config = function()
  --     require('orgmode').setup_ts_grammar()

  --     require'nvim-treesitter.configs'.setup {
  --       -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
  --       highlight = {
  --         enable = true,
  --         -- disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
  --         additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
  --       },
  --       ensure_installed = {'org'}, -- Or run :TSUpdate org
  --     }
  --     require('orgmode').setup{
  --       org_agenda_files = "~/org/*",
  --       -- org_agenda_files = "~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/*",
  --       org_default_notes_file = "~/org/inbox.org",
  --       org_todo_keywords = {'TODO(t)', 'WAITING(w)', '|', 'DONE(d)', 'DELEGATED(D)'},
  --       org_agenda_templates = {
  --         -- T = { description = 'Todo', template = '* TODO %?\n %u', target = '~/org/todo.org' },
  --         j = { description = 'Journal',
  --               template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
  --               target = '~/sync/org/journal.org' },
  --       },
  --     }

  --     local opts = { noremap = true, silent = true }
  --     vim.api.nvim_set_keymap("n",
  --       "<Leader>ooo",
  --       ":edit ~/org/inbox.org<CR>", opts)
  --   end
  -- }

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

  'lervag/vimtex',
  'lervag/wiki.vim',
  'lervag/wiki-ft.vim',
}


local function ensure_lazy_installed()
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    })
  end
  if not vim.tbl_contains(vim.opt.rtp:get(), lazypath) then
    vim.opt.rtp:prepend(lazypath)
  end
end

function M.setup()
  vim.g.no_python_maps = 1

  ensure_lazy_installed()
  require('lazy').setup(spec)
end

return M
