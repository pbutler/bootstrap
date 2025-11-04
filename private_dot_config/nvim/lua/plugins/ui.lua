return {
	{
		"uga-rosa/ccc.nvim",
		opts = {},
		cmd = {
			"CccPick",
			"CccConvert",
			"CccHighlighterEnable",
			"CccHighlighterDisable",
			"CccHighlighterToggle",
		},
	},
	-- {
	-- 	"nvim-mini/mini.indentscope",
	-- 	opts = {
	-- 		draw = {
	-- 			animation = function()
	-- 				return 0
	-- 			end,
	-- 		},
	-- 	},
	-- },
	{
		"alexghergh/nvim-tmux-navigation",
		keys = {
			{ "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>" },
			{ "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>" },
			{ "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>" },
			{ "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>" },
			{ "<C-\\>", "<Cmd>NvimTmuxNavigateLastActive<CR>" },
			{ "<C-Space>", "<Cmd>NvimTmuxNavigateNext<CR>" },
		},
		config = function()
			require("nvim-tmux-navigation").setup({
				disable_when_zoomed = true, -- defaults to false
				keybindings = {
					left = "<C-h>",
					down = "<C-j>",
					up = "<C-k>",
					right = "<C-l>",
					last_active = "<C-\\>",
					next = "<C-Space>",
				},
			})
		end,
	},
}
