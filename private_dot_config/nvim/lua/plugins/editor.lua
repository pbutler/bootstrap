local Util = require("lazyvim.util")
return {
	-- {
	--   "hrsh7th/nvim-cmp",
	--   opts = function(_, opts)
	--     local cmp = require("cmp")
	--     opts.mapping = {
	--       ["<Down>"] = {
	--         i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
	--       },
	--       ["<Up>"] = {
	--         i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
	--       },
	--       ["<Tab>"] = cmp.mapping.select_next_item(),
	--       ["<S-Tab>"] = cmp.mapping.select_prev_item(),
	--       ["<C-b>"] = cmp.mapping.scroll_docs(-4),
	--       ["<C-f>"] = cmp.mapping.scroll_docs(4),
	--       ["<C-Space>"] = cmp.mapping.complete(),
	--       ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	--       ["<C-y>"] = cmp.mapping.confirm({ select = false }),
	--       ["<S-CR>"] = cmp.mapping.confirm({
	--         behavior = cmp.ConfirmBehavior.Replace,
	--         select = true,
	--       }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	--       ["<C-e>"] = cmp.mapping.abort(),
	--       ["<C-CR>"] = function(fallback)
	--         cmp.abort()
	--         fallback()
	--       end,
	--     }
	--   end,
	-- },
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		enabled = true,
		keys = {
			{
				"<C-n>",
				function()
					require("luasnip").jump(1)
				end,
				desc = "Jump to next snippet location",
				mode = { "i", "s" },
			},
			{
				"<C-p>",
				function()
					require("luasnip").jump(-1)
				end,
				desc = "Jump to previous snippet location",
				mode = { "i", "s" },
			},
			{
				"<Tab>",
				false,
				mode = { "i", "s" },
			},
			{
				"<S-Tab>",
				false,
				mode = { "i", "s" },
			},
		},
		build = "make install_jsregexp",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_snipmate").lazy_load({ paths = { "~/.vim/UltiSnips/" } })
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{
				"danielfalk/smart-open.nvim",
				opts = {},
				config = function()
					require("telescope").load_extension("smart_open")
				end,
				dependencies = {
					"kkharji/sqlite.lua",
					"nvim-telescope/telescope-fzy-native.nvim",
					"nvim-tree/nvim-web-devicons",
				},
				keys = {
					{
						"<leader>sf",
						function()
							require("telescope").extensions.smart_open.smart_open({ cwd_only = true })
						end,
						desc = "search files by frecency",
					},
				},
			},
		},
		opts = {
			defaults = {
				path_display = { "truncate" },
				mappings = {
					i = {
						["<c-f>"] = function(...)
							return require("telescope.actions").results_scrolling_down(...)
						end,
						["<c-b>"] = function(...)
							return require("telescope.actions").results_scrolling_up(...)
						end,
						["<c-u>"] = false,
						["<c-d>"] = false,
					},
					n = {
						["<c-f>"] = function(...)
							return require("telescope.actions").results_scrolling_down(...)
						end,
						["<c-b>"] = function(...)
							return require("telescope.actions").results_scrolling_up(...)
						end,
						["<c-d>"] = function(...)
							return require("telescope.actions").preview_scrolling_down(...)
						end,
						["<c-u>"] = function(...)
							return require("telescope.actions").preview_scrolling_up(...)
						end,
					},
				},
			},
			pickers = {
				buffers = {
					theme = "dropdown",
					previewer = false,
				},
			},
		},
		keys = {
			{
				"<leader>sG",
				function()
					require("telescope.builtin").grep_string()
				end,
				desc = "grep word under cursor",
			},
			{
				"<leader>sga",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "grep search all",
			},
			{
				"<leader>sgp",
				function()
					require("telescope.builtin").live_grep({
						glob_pattern = {
							"!*test*",
						},
					})
				end,
				desc = "grep search production (exclude test files)",
			},
			{
				"<leader>sgt",
				function()
					require("telescope.builtin").live_grep({ glob_pattern = { "*test*" } })
				end,
				"search tests",
			},
		},
	},
	{
		"axkirillov/hbac.nvim",
		dependencies = {
			-- these are optional, add them, if you want the telescope module
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {},
		event = { "BufRead", "BufNewFile" },
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		keys = function()
			return {
				{
					"<leader>ef",
					function()
						require("neo-tree.command").execute({ toggle = true, dir = Util.root() })
					end,
					desc = "Explorer NeoTree (root dir)",
				},
				{
					"<leader>eF",
					function()
						require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
					end,
					desc = "Explorer NeoTree (cwd)",
				},
				{
					"<leader>eg",
					function()
						require("neo-tree.command").execute({ source = "git_status", toggle = true })
					end,
					desc = "Git explorer",
				},
				{
					"<leader>eb",
					function()
						require("neo-tree.command").execute({ source = "buffers", toggle = true })
					end,
					desc = "Buffer explorer",
				},
			}
		end,
	},
	{
		"ojroques/nvim-osc52",
		keys = function()
			local osc52 = require("osc52")
			return {
				{ "<leader>y", osc52.copy_operator, desc = "Yank", mode = "n", expr = true },
				{ "<leader>yy", "<leader>y_", desc = "Yank this line", mode = "n", remap = true },
				{ "<leader>y", osc52.copy_visual, desc = "Yank Visual", mode = "v" },
			}
		end,
	},
	-- {
	-- 	"lukas-reineke/indent-blankline.nvim",
	-- 	main = "ibl",
	-- 	opts = {},
	-- 	config = function()
	-- 		local highlight = {
	-- 			"IndentBlanklineIndent1",
	-- 			"IndentBlanklineIndent2",
	-- 		}

	-- 		local hooks = require("ibl.hooks")
	-- 		-- create the highlight groups in the highlight setup hook, so they are reset
	-- 		-- every time the colorscheme changes
	-- 		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	-- 			vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { bg = "#181926" })
	-- 			vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", { bg = "#1e2030" })
	-- 		end)

	-- 		require("ibl").setup({
	-- 			indent = {
	-- 				highlight = highlight,
	-- 				char = "",
	-- 			},
	-- 			whitespace = {
	-- 				highlight = highlight,
	-- 				remove_blankline_trail = false,
	-- 			},
	-- 			scope = { highlight = highlight },
	-- 		})

	-- 		vim.g.rainbow_delimiters = { highlight = highlight }

	-- 		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
	-- 	end,
	-- },
}
