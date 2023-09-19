-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    "lifepillar/vim-mucomplete",

	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
	},

	"nvim-treesitter/nvim-treesitter-textobjects",
	"jose-elias-alvarez/null-ls.nvim",

	-- Git related plugins
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
	"lewis6991/gitsigns.nvim",

	"numToStr/Navigator.nvim",
	"windwp/nvim-autopairs",
	"nvim-lualine/lualine.nvim", -- Fancier statusline
	"lukas-reineke/indent-blankline.nvim", -- Add indentation guides even on blank lines
	"numToStr/Comment.nvim", -- "gc" to comment visual regions/lines
	-- "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	--"ghillb/cybu.nvim",
	"kyazdani42/nvim-web-devicons",
	"norcalli/nvim-colorizer.lua",
    { 'echasnovski/mini.nvim', version = false },
    -- 'echasnovski/mini.surround',
	-- "echasnovski/mini.align",
	"bluz71/vim-moonfly-colors",
    'projekt0n/github-nvim-theme',
    { "lervag/vimtex",
        config = function ()
        vim.g.vimtex_view_general_viewer = 'sumatrapdf'
        vim.g.vimtex_compiler_method = 'tectonic'
        end
    },
    {
        'kaarmu/typst.vim',
        ft = 'typst',
        lazy=false,
    },
    "duane9/nvim-rg",
	"Tetralux/odin.vim",
    "haringsrob/nvim_context_vt",
	-- Fuzzy Finder (files, lsp, etc)
	{ "nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" }
	},

	-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
	-- { "nvim-telescope/telescope-fzf-native.nvim",
	-- 	build = "make",
	-- 	cond = vim.fn.executable("make") == 1
	-- },

	{
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	},
    {
        "smoka7/multicursors.nvim",
        event = "VeryLazy",
        dependencies = {
            'smoka7/hydra.nvim',
        },
        opts = {},
        cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    }
}

require("lazy").setup(plugins)

-------------------------
-- ----- OPTIONS ----- --
-------------------------

local set = vim.opt

vim.cmd([[language en_US]])

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
set.relativenumber = false -- Show line numbers
set.signcolumn = "yes"
set.cursorline = true -- Highlight cursorline
-- set.cursorcolumn = true       -- Highlight cursorcolumn
-- set.colorcolumn = "81,101"
set.splitbelow = true
set.splitright = true

set.mouse = "a"
set.swapfile = false
set.report = 0 -- Tell when anyting is changed by : <cmd>
set.clipboard = "unnamedplus"

-- set.spelllang = ru_ru,en_us
set.langmap = "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,"
	.. "фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

-- set path
set.path = vim.opt.path + 'code/**'

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
vim.cmd([[colorscheme github_dark_high_contrast]])

-- Set completeopt to have a better completion experience
set.completeopt = "menuone,noselect"
set.inccommand = "split"

-------------------------
-- ----- REQUIRE ----- --
-------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = '\\'

-- require("custom.treesitter")
-- require("custom.lsp")
-- require("custom.lualine")
-- require("custom.cybu")
require("custom.mini")

require("Comment").setup()
require("Navigator").setup()
--require("nvim-autopairs").setup({})
--require("nvim-surround").setup({})

-- require('indent_blankline').setup {
--     char = '┊',
--     show_trailing_blankline_indent = false,
-- }

require("gitsigns").setup()
require("nvim_context_vt").setup({
    min_rows = 1,
})

-------------------------
-- ----- KEYMAPS ----- --
-------------------------

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("n", "<leader>l", ":nohl<CR>", { silent = true })
vim.keymap.set("n", "<leader>ec", ":e $MYVIMRC<CR>", { silent = true })
vim.keymap.set("n", "<leader>ee", ":25Lex<CR>", { silent = true })

vim.keymap.set("n", "<C-S>", ":w<CR>")

vim.keymap.set("n", "<leader>G", "<C-]>", { silent = true, desc = "Go to definition (CTags)" })
vim.keymap.set("n", "<leader>g", "<C-w>}<C-w>H", { silent = true, desc = "Preview definition (CTags)" })
-- vim.keymap.set("n", "<leader>s", ":ts<CR>", { silent = true, desc = "Select tag (CTags)"})
vim.keymap.set("n", "<leader>i", "<C-I>", { silent = true, desc = "Jump forward" })
vim.keymap.set("n", "<leader>o", "<C-O>", { silent = true, desc = "Jump back" })

vim.keymap.set({ 'v', 'n' }, '<Leader>m', '<cmd>MCstart<cr>', {desc = 'Create a selection for selected text or word under the cursor'})
-- Odin go to def
set.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.keymap.set("n", "<leader>r", ":silent lgrep <cword> C:/Users/user/scoop/apps/odin-nightly/2023-07-30/<CR>:lopen<CR>")

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set({ "n", "x", "o" }, "H", "g^")
vim.keymap.set({ "n", "x", "o" }, "L", "g$")

-- Put semicolon at the end of the line
vim.keymap.set("i", "<A-;>", "<Esc>miA;<Esc>`ii")

-- Telescope keybinds
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in buffer]" })

vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fw", require("telescope.builtin").grep_string, { desc = "[F]ind current [W]ord" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "[F]ind by [G]rep" })
vim.keymap.set("n", "<leader>fj", require("telescope.builtin").jumplist, { desc = "[F]ind in [J]umplist" })
vim.keymap.set("n", "<leader>ft", require("telescope.builtin").jumplist, { desc = "[F]ind in [T]ags" })
vim.keymap.set("n", "<leader>fd", require("telescope.builtin").diagnostics, { desc = "[F]ind [D]iagnostics" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>k", vim.diagnostic.open_float, { desc = "Open diagnostics" })

-- Cybu --
-- vim.keymap.set("n", "gp", "<Plug>(CybuPrev)")
-- vim.keymap.set("n", "gn", "<Plug>(CybuNext)")

-- Buffers --
vim.keymap.set("n", "gp", ":bprevious<CR>")
vim.keymap.set("n", "gn", ":bnext<CR>")

-- Navigator(tmux) --
-- vim.keymap.set("n", "<C-h>", "<CMD>NavigatorLeft<CR>")
-- vim.keymap.set("n", "<C-l>", "<CMD>NavigatorRight<CR>")
-- vim.keymap.set("n", "<C-k>", "<CMD>NavigatorUp<CR>")
-- vim.keymap.set("n", "<C-j>", "<CMD>NavigatorDown<CR>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-j>", "<C-w>j")

-- Increment/Decrement --
vim.keymap.set("n", "<leader>a", "<C-a>", { desc = "Increment" })
vim.keymap.set("n", "<leader>x", "<C-x>", { desc = "Decrement" })
vim.keymap.set("n", "<up>", "<C-a>", { desc = "Increment" })
vim.keymap.set("n", "<down>", "<C-x>", { desc = "Decrement" })

-- Formatting --
vim.keymap.set("n", "<leader>F", vim.lsp.buf.format, { desc = "Format buffer"})

-- insert en_US symbols from russian keyboard --
vim.keymap.set("n", "<leader>2", "i@<esc>")
vim.keymap.set("n", "<leader>3", "i#<esc>")
vim.keymap.set("n", "<leader>4", "i$<esc>")
vim.keymap.set("n", "<leader>7", "i&<esc>")
vim.keymap.set("i", "<A-2>", "@")
vim.keymap.set("i", "<A-3>", "#")
vim.keymap.set("i", "<A-4>", "$")
vim.keymap.set("i", "<A-7>", "&")
------------------------------
-- ----- AUTOCOMMANDS ----- --
------------------------------

-- [[ Highlight on yank ]]
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	pattern = "*",
})

-- [[ Autoresize windows ]]
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

-- [[ Close with q in readonly buffers ]]
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR> 
      set nobuflisted 
    ]]
  end,
})
-- Do not put additional comment sign after pressing enter
vim.cmd("autocmd BufEnter * set formatoptions-=cro")
vim.cmd("autocmd BufEnter * setlocal formatoptions-=cro")
vim.cmd("autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0")
vim.cmd("autocmd FileType lua set expandtab ts=4 shiftwidth=4 softtabstop=4")
vim.cmd("autocmd FileType c,h set expandtab ts=4 shiftwidth=4 softtabstop=4")
vim.cmd("autocmd FileType odin set expandtab ts=2 shiftwidth=2 softtabstop=2")
vim.cmd("autocmd FileType go set expandtab ts=4 shiftwidth=4 softtabstop=4")
vim.cmd("autocmd FileType typ set expandtab ts=2 shiftwidth=2 softtabstop=2 nu linebreak")

if vim.g.nvy then
    vim.o.guifont = "Iosevka:h16"
    vim.keymap.set({"n", "i", "v"}, "<C-S-v>", "<C-R>+")
end

if vim.g.neovide then
    -- Put anything you want to happen only in Neovide here
    vim.o.guifont = "Iosevka:h15"
    vim.g.neovide_cursor_animation_length = 0.05

    vim.keymap.set({"n", "i", "v"}, "<C-S-v>", "<C-R>+")
end
