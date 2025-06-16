-- vim.o
vim.o.autochdir = false
vim.o.autoindent = true
vim.o.autoread = true
vim.o.background = "dark"
vim.o.backup = false
vim.o.clipboard = "unnamedplus"
vim.o.cmdheight = 0
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.fileencoding = "utf-8"
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.incsearch = false
vim.o.number = true
vim.o.shiftround = true
vim.o.shiftwidth = 4
vim.o.showcmd = true
vim.o.showmatch = true
vim.o.showmode = false
vim.o.showtabline = 2
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.softtabstop = 4
vim.o.splitbelow = true
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.wildmenu = true
vim.o.wrap = false
vim.o.writebackup = false

-- vim.opt
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.termguicolors = true

-- vim.g
vim.g.encoding = "utf-8"
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.editorconfig = true

-- keymap
vim.api.nvim_set_keymap("n", "<S-h>", "<C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-j>", "<C-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-k>", "<C-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-l>", "<C-w>l", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<A-Up>", ":m-2<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<A-Down>", ":m+<cr>", { silent = true })

vim.api.nvim_set_keymap("n", "<leader>v", "<cmd>edit $MYVIMRC<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>q", "<cmd>wqa<cr>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<C-f>", "*", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>a", "gg<S-v>G", { noremap = true, silent = true })

-- folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local mirror = "https://ghproxy.net/"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		mirror .. "https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local opts = {
	git = {
		url_format = mirror .. "https://github.com/%s.git",
	},
	checker = {
		enabled = true,
		notify = false,
	},
}

local lsps = {
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		opts = {},
	},
	{
		"williamboman/mason.nvim",
		opts = {
			max_concurrent_installers = require("math").huge,
			github = {
				download_url_template = mirror .. "https://github.com/%s/releases/download/%s/%s",
			},
			ui = {
				icons = {
					package_installed = "++",
					package_pending = "->",
					package_uninstalled = "--",
				},
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
				"stylua",
				"gopls",
			},
		},
	},
}

local treesitters = {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.install").prefer_git = true
			for _, config in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
				config.install_info.url =
					config.install_info.url:gsub("https://github.com/", mirror .. "https://github.com/")
			end

			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
				},
				auto_install = true,
				sync_install = true,
				indent = {
					enable = true,
				},
				modules = {},
				ensure_installed = {},
				ignore_install = {},
				autotag = {
					enable = true,
				},
			})
		end,
	},
	{
		"Wansmer/treesj",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{ "<leader>j", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
		},
		opts = {
			use_default_keymaps = false,
			max_join_length = 150 * 2,
		},
	},
	{
		"xzbdmw/colorful-menu.nvim",
		opts = {},
	},
}

local lines = {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"i314q159/lsc",
		},
		opts = {
			options = {
				icons_enabled = true,
				section_separators = "",
				component_separators = "",
			},
			sections = {
				lualine_b = {
					"branch",
					"diff",
					"diagnostics",
				},
				lualine_c = {
					{ "filename", path = 2 },
				},
				lualine_x = {
					{
						require("lazy.status").updates,
						cond = require("lazy.status").has_updates,
					},
					{
						function()
							return require("lsp-info").lsp_info()
						end,
					},
					{ "datetime", style = "iso" },
					{
						function()
							return require("lsc").loaded_slash_count()
						end,
					},
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
			},
		},
	},
	{
		"i314q159/lsp-info",
		opts = {},
	},
}

local folkes = {
	{
		"folke/which-key.nvim",
		opts = {
			auto_show = false,
		},
		keys = {
			{ "<leader>k", "<cmd>WhichKey<cr>", desc = "WhichKey" },
		},
		lazy = false,
	},
	-- { "folke/neodev.nvim", opts = {} },
	{
		"folke/todo-comments.nvim",
		lazy = false,
		opts = {},
	},
	{
		"folke/trouble.nvim",
		keys = {
			{ "<leader>t", "<cmd>TroubleToggle<cr>", desc = "Trouble Toggle" },
		},
		opts = {
			position = "bottom",
			icons = true,
			auto_close = true,
		},
		lazy = false,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "moon",
			transparent = false,
		},
	},
	{
		"folke/snacks.nvim",
		opts = {
			indent = {
				enabled = true,
			},
		},
	},
	{
		"folke/lazydev.nvim",
		opts = {},
	},
}

local icons = {
	{
		"echasnovski/mini.icons",
	},
	{
		"nvim-tree/nvim-web-devicons",
		opts = {},
	},
}

local fmts = {
	{
		"sbdchd/neoformat",
	},
}

local cmps = {
	{
		"saghen/blink.cmp",
		version = "1.*",
		-- build = "cargo build --release",
		opts = {
			keymap = {
				preset = "super-tab",
			},
		},
	},
}

local colorschemes = {
    {
        "catppuccin/nvim",
        opts = {}
    }
}

local plugins = {
	cmps,
	fmts,
	folkes,
	icons,
	lines,
	lsps,
	treesitters,
    colorschemes,
	{
		"mateuszwieloch/automkdir.nvim",
		"nvim-lua/plenary.nvim",
		"kilavila/nvim-gitignore",
	},
	{
		"axieax/urlview.nvim",
		lazy = false,
		keys = {
			{ "<leader>u", "<cmd>UrlView buffer<cr>", desc = "Urlview Buffer" },
		},
		opts = {},
	},
	{
		"nguyenvukhang/nvim-toggler",
		keys = {
			{ "<leader>i", "require('nvim-toggler').toggle", desc = "Toggle Word" },
		},
		opts = {},
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			toggler = { line = "<C-\\>" },
		},
	},
	{
		"windwp/nvim-autopairs",
		opts = {},
	},
	{
		"toppair/reach.nvim",
		cmd = { "ReachOpen" },
		opts = {},
		keys = {
			{ "<leader>b", "<cmd>ReachOpen buffers<cr>", desc = "ReachOpen Buffers" },
		},
	},
	{
		"ethanholz/nvim-lastplace",
		opts = {},
	},
	{
		"NvChad/nvim-colorizer.lua",
		opts = {
			user_default_options = {
				mode = "virtualtext",
			},
		},
	},
	{
		"chentoast/marks.nvim",
		opts = {},
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {},
		keys = {
			{ "<leader>h", "<cmd>Gitsigns preview_hunk<cr>", desc = "Gitsigns Preview Hunk" },
			{ "<leader>n", "<cmd>Gitsigns next_hunk<cr><cr>", desc = "Gitsigns Next Hunk" },
		},
		lazy = false,
	},
	{
		"kevinhwang91/nvim-hlslens",
		opts = {},
	},
	{
		"nacro90/numb.nvim",
		opts = {},
	},
	{
		"VidocqH/lsp-lens.nvim",
		opts = {},
	},
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
	{
		"elentok/togglr.nvim",
		opts = {
			key = "<leader>i",
		},
	},
	{
		"elentok/scriptify.nvim",
		keys = {
			{ "<leader>s", "<cmd>Scriptify<cr>", desc = "Scriptify" },
		},
		opts = {},
		cmd = { "Scriptify" },
	},
	{
		"roobert/f-string-toggle.nvim",
		opts = {
			key_binding = "fs",
		},
	},
	{
		"vidocqh/auto-indent.nvim",
		opts = {},
	},
	{
		"chrisgrieser/nvim-puppeteer",
		lazy = false,
	},
	{
		"sontungexpt/stcursorword",
		event = "VeryLazy",
		config = true,
	},
	{
		"f-person/git-blame.nvim",
		keys = {
			{ "<leader>g", "<cmd>GitBlameToggle<cr>", desc = "GitBlame Toggle" },
		},
		opts = {},
		lazy = false,
	},
	{
		"m-demare/hlargs.nvim",
		opts = {},
	},
	{
		"nvim-telescope/telescope.nvim",
		keys = {
			{ "<leader>f", "<cmd>Telescope<cr>", desc = "Telescope" },
		},
		opts = {},
	},
	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		keys = {
			{ "<leader>o", "<cmd>Outline<cr>", desc = "Toggle Outline" },
		},
		opts = {
			outline_window = {
				width = 30,
				relative_width = true,
				auto_jump = true,
				show_numbers = true,
				show_relative_numbers = true,
				wrap = true,
			},
		},
	},
	{
		"sQVe/sort.nvim",
		opts = {},
	},
	{
		"windwp/nvim-ts-autotag",
		opts = {},
	},
	{
		"xlboy/vscode-opener.nvim",
		keys = {
			{ "<leader>c", "<cmd>lua require('vscode-opener').open()<CR>", desc = "Open VSCode Opener Menu" },
		},
	},
	{
		"okuuva/auto-save.nvim",
		version = "^1.0.0",
		event = {
			"InsertLeave",
			"TextChanged",
		},
	},
	{
		"echasnovski/mini.diff",
		version = "*",
		opts = {},
	},
	{
		"petertriho/nvim-scrollbar",
		opts = {},
	},
	{
		"nvzone/showkeys",
		cmd = "ShowkeysToggle",
		opts = {
			maxkeys = 5,
		},
	},
	{
		"cappyzawa/trim.nvim",
		opts = {},
	},
}

require("lazy").setup(plugins, opts)
vim.cmd("colorscheme tokyonight-moon")
vim.api.nvim_set_keymap("n", "<leader>l", "<cmd>Lazy<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>m", "<cmd>Mason<cr>", { noremap = true, silent = true })
