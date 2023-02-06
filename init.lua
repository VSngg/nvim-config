-- Install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	is_bootstrap = true
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
	vim.cmd([[packadd packer.nvim]])
end

require("packer").startup(function(use)
	-- Package manager
	use("wbthomason/packer.nvim")

	use({ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		requires = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"j-hui/fidget.nvim",
		},
	})

	use({ -- Autocompletion
		"hrsh7th/nvim-cmp",
		requires = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
	})

	use("rafamadriz/friendly-snippets")

	use({ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		run = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
	})

	use({ -- Additional text objects via treesitter
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
	})

	use("jose-elias-alvarez/null-ls.nvim")

	-- Git related plugins
	use("tpope/vim-fugitive")
	use("tpope/vim-rhubarb")
	use("lewis6991/gitsigns.nvim")

	use("numToStr/Navigator.nvim")
	use("windwp/nvim-autopairs")
	use("nvim-lualine/lualine.nvim") -- Fancier statusline
	use("lukas-reineke/indent-blankline.nvim") -- Add indentation guides even on blank lines
	use("numToStr/Comment.nvim") -- "gc" to comment visual regions/lines
	use("tpope/vim-sleuth") -- Detect tabstop and shiftwidth automatically
	use("ghillb/cybu.nvim")
	use("kyazdani42/nvim-web-devicons")
	use("kvrohit/rasmus.nvim")
	use("norcalli/nvim-colorizer.lua")
	use("kylechui/nvim-surround")
	use("Vonr/align.nvim")
	use("bluz71/vim-moonfly-colors")

	-- Fuzzy Finder (files, lsp, etc)
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x", requires = { "nvim-lua/plenary.nvim" } })

	-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make", cond = vim.fn.executable("make") == 1 })

	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	})

	-- Add custom plugins to packer from /nvim/lua/custom/plugins.lua
	local has_plugins, plugins = pcall(require, "custom.plugins")
	if has_plugins then
		plugins(use)
	end

	if is_bootstrap then
		require("packer").sync()
	end
end)

-------------------------
-- ----- OPTIONS ----- --
-------------------------

local set = vim.opt

set.showcmd = false -- Show (partial) command in status line
set.showmode = false
set.showmatch = true -- Show matching brackets
set.matchtime = 3 -- Set matching brackets time
set.cmdheight = 1
set.cmdwinheight = 10

set.autowrite = true -- Automatically save when editing multiple files
set.hidden = true -- Hide buffers when they are abandoned
set.encoding = "utf-8"
set.pumheight = 10 -- Pop-up menu height

set.scrolloff = 5
set.number = true -- Show line numbers
set.relativenumber = true -- Show line numbers
set.signcolumn = "yes"
set.cursorline = true -- Highlight cursorline
-- set.cursorcolumn = true       -- Highlight cursorcolumn
set.colorcolumn = "81,101"
set.splitbelow = true
set.splitright = true

set.mouse = "a"
set.swapfile = false
set.report = 0 -- Tell when anyting is changed by : <cmd>
set.clipboard = "unnamedplus"

-- set.spelllang = ru_ru,en_us
set.langmap = "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,"
	.. "фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

-- ----- Enable folding ----- --

set.foldmethod = "indent"
set.foldlevel = 256

-- ----- Statusline ----- --

set.ruler = true
set.laststatus = 3 --always show status line
set.showtabline = 1

set.history = 2500

-- ----- Search ----- --

set.incsearch = true
set.hlsearch = true
set.ignorecase = true
set.smartcase = true -- Do smart case matching
set.magic = true --extended regexes
set.wrapscan = true --wrap while searching

-- ----- Tabbing ----- --

set.expandtab = true
set.shiftwidth = 4
set.tabstop = 4

-- ----- Indent ----- --

set.autoindent = true
set.smartindent = true
set.cindent = true

-- Set colorscheme
set.termguicolors = true
set.background = "dark"
vim.cmd([[colorscheme moonfly]])

-- Set completeopt to have a better completion experience
set.completeopt = "menuone,noselect"
set.inccommand = "split"

-------------------------
-- ----- REQUIRE ----- --
-------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("custom.treesitter")
require("custom.lsp")
require("custom.lualine")
require("custom.cybu")

require("Comment").setup()
require("Navigator").setup()
require("nvim-autopairs").setup({})
require("nvim-surround").setup({})

-- require('indent_blankline').setup {
--     char = '┊',
--     show_trailing_blankline_indent = false,
-- }

require("gitsigns").setup()

-------------------------
-- ----- KEYMAPS ----- --
-------------------------

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("n", "<leader>l", ":nohl<CR>", { silent = true })
vim.keymap.set("n", "<leader>w", ":wq<CR>", { silent = true })
vim.keymap.set("n", "<leader>q", ":q<CR>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Telescope keybinds
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer]" })

vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files,  { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags,   { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fw", require("telescope.builtin").grep_string, { desc = "[F]ind current [W]ord" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep,   { desc = "[F]ind by [G]rep" })
vim.keymap.set("n", "<leader>fd", require("telescope.builtin").diagnostics, { desc = "[F]ind [D]iagnostics" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>k", vim.diagnostic.open_float, { desc = "Open diagnostics in a floating window" })

-- Cybu --
vim.keymap.set("n", "H", "<Plug>(CybuPrev)")
vim.keymap.set("n", "L", "<Plug>(CybuNext)")

-- Navigator(tmux) --
vim.keymap.set("n", "<C-h>", "<CMD>NavigatorLeft<CR>")
vim.keymap.set("n", "<C-l>", "<CMD>NavigatorRight<CR>")
vim.keymap.set("n", "<C-k>", "<CMD>NavigatorUp<CR>")
vim.keymap.set("n", "<C-j>", "<CMD>NavigatorDown<CR>")

-- Increment/Decrement --
vim.keymap.set("n", "<leader>a", "<C-a>", { desc = "Increment" })
vim.keymap.set("n", "<leader>x", "<C-x>", { desc = "Decrement" })
vim.keymap.set("n", "<up>", "<C-a>",      { desc = "Increment" })
vim.keymap.set("n", "<down>", "<C-x>",    { desc = "Decrement" })

-- Formatting --
vim.keymap.set("n", "<leader>F", vim.lsp.buf.format)

-- Align --
local NS = { noremap = true, silent = true }

vim.keymap.set('x', '<leader>Aa',
	function() require'align'.align_to_char(1, true)
	end, NS , { desc = "Aligns to 1 character, looking left" })
vim.keymap.set('x', '<leader>As',
	function() require'align'.align_to_char(2, true, true)
	end, NS , { desc = "Aligns to 2 characters, looking left and with previews"})
vim.keymap.set('x', '<leader>Aw',
	function() require'align'.align_to_string(false, true, true)
	end, NS) -- Aligns to a string, looking left and with previews
vim.keymap.set('x', '<leader>Ar',
	function() require'align'.align_to_string(true, true, true)
	end, NS) -- Aligns to a Lua pattern, looking left and with previews

-- insert en_US symbols from russian keyboard --
vim.keymap.set("n", "<leader>2", "i@<esc>")
vim.keymap.set("n", "<leader>3", "i#<esc>")
vim.keymap.set("n", "<leader>4", "i$<esc>")
vim.keymap.set("n", "<leader>7", "i&<esc>")
------------------------------
-- ----- AUTOCOMMANDS ----- --
------------------------------

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- Do not put additional comment sign after pressing enter
vim.cmd("autocmd BufEnter * set formatoptions-=cro")
vim.cmd("autocmd BufEnter * setlocal formatoptions-=cro")
vim.cmd("autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0")
