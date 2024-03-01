#local colors = require("catppuccin.palettes").get_palette() -- fetch colors from palette
return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "macchiato",
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
      color_overrides = {
        macchiato = {
          rosewater = "#eee8d5", -- Rosewater
          flamingo = "#F2CDCD", -- Flamingo
          mauve = "#d33682", -- Mauve
          pink = "#5f5faf", -- F5C2E7", -- Pink
          red = "#dc322f", -- Red
          maroon = "#af005f", -- Maroon
          peach = "#cb4b16", -- Peach
          yellow = "#b58900", -- Yellow
          green = "#859900", -- Green
          blue = "#268bd2", -- Blue
          sky = "#0087ff", -- Sky
          teal = "#2aa198", -- Teal
          lavender = "#6c71c4", -- Lavender
          -- white = "#d7d7af", -- White
          text = "#839496",

          overlay2 = "#93a1a1", -- Gray2
          subtext0 = "#657b83", -- Gray1
          surface2 = "#586e75", -- Gray0
          surface1 = "#21505C", -- Black4
          subtext1 = "#14434F", -- Black3
          surface0 = "#073642", -- Black2
          overlay1 = "#002b36", -- Black1
          overlay0 = "#fdf6e3", -- Black0
          -- overlay0 = "#001E29", -- Black0

          base =   "#002b36",
          mantle = "#073642",
          crust =  "#001e29"
        }
      },
      custom_highlights = {
        CmpItemAbbrMatch = { fg = require("catppuccin.palettes").get_palette().rosewater, style = { "bold" } },
        CmpItemAbbrMatchFuzzy = { fg = require("catppuccin.palettes").get_palette().rosewater, style = { "bold" } },
      }
    }
  },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
