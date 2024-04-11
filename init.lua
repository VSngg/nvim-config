vim.g.mapleader = " "
vim.g.maplocalleader = '\\'

-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({ "git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    {"lewis6991/gitsigns.nvim", opts={}},
	"kyazdani42/nvim-web-devicons",
	"bluz71/vim-moonfly-colors",
    'projekt0n/github-nvim-theme',
    { 'kaarmu/typst.vim', ft = 'typst', lazy=false, },
	"Tetralux/odin.vim",
    "tikhomirov/vim-glsl",
    { "haringsrob/nvim_context_vt",
        config = function()
        require("nvim_context_vt").setup({
            min_rows = 1,
        })
        end,
    },
    { 'shoumodip/compile.nvim',
        config = function()
            local compile = require("compile")
            compile.bind {
                ["n"] = compile.next,      -- Open the next error
                ["p"] = compile.prev,      -- Open the previous error
                ["o"] = compile.this,      -- Open the error under the cursor
                ["r"] = compile.restart,   -- Restart the compilation process
                ["q"] = compile.interrupt, -- Kill the compilation process
            }
        end,
    },
    "nvim-pack/nvim-spectre",

    { 'echasnovski/mini.nvim', version = false,
    config = function()
        require('mini.align').setup()
        require('mini.surround').setup()
        require('mini.statusline').setup({ set_vim_settings = false, })
        require('mini.tabline').setup()
        require('mini.completion').setup()
        require('mini.comment').setup()

        local miniclue = require('mini.clue')
        miniclue.setup({
            window = {col = 40},
            triggers = {
                -- Leader triggers
                { mode = 'n', keys = '<Leader>' },
                { mode = 'x', keys = '<Leader>' },
                -- `g` key
                { mode = 'n', keys = 'g' },
                { mode = 'x', keys = 'g' },

                -- Marks
                { mode = 'n', keys = "'" },
                { mode = 'n', keys = '`' },
                { mode = 'x', keys = "'" },
                { mode = 'x', keys = '`' },

                -- Registers
                { mode = 'n', keys = '"' },
                { mode = 'x', keys = '"' },
                { mode = 'i', keys = '<C-r>' },
                { mode = 'c', keys = '<C-r>' },

                -- Window commands
                { mode = 'n', keys = '<C-w>' },

                -- `z` key
                { mode = 'n', keys = 'z' },
                { mode = 'x', keys = 'z' },
            },

            clues = {
                miniclue.gen_clues.g(),
                miniclue.gen_clues.marks(),
                miniclue.gen_clues.registers(),
                miniclue.gen_clues.windows(),
                miniclue.gen_clues.z(),
            },
        })
    end,
    },
    -- Add indentation guides even on blank lines
    { "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup({
                indent = { highlight = "Whitespace", char = '▏' },
                scope = { enabled = false },
            })
        end,

    },
	-- Fuzzy Finder (files, lsp, etc)
	{ "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } , },
    { "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },

        config = function()
            require("neo-tree").setup({
                filesystem = {
                    window = {
                        width = "20%",
                        position = "left",
                    },
                    hijack_netrw_behavior = "open_current",
                },
            })
        end,
    },
    {'Wansmer/langmapper.nvim', lazy = false,
        priority = 1, -- High priority is needed if you will use `autoremap()`
        config = function()
            require('langmapper').setup({--[[ your config ]]})
        end,
    },
	{"epwalsh/obsidian.nvim",
		version = "*",  -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		dependencies = { "nvim-lua/plenary.nvim", },
		opts = {
            workspaces = {
                {
                    name = "personal",
                    path = "~/Vault",
                },
            },
        },
	},
    -- {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
    {'neovim/nvim-lspconfig'},
}

require("lazy").setup(plugins)

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = {buffer = event.buf}
        local map = vim.keymap.set

        vim.diagnostic.disable()
        map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts, {desc = "LSP: Hover info"})
        map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts, {desc = "LSP: Goto definition"})
        map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts, {desc = "LSP: Goto declaration"})
        map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts, {desc = "LSP: Goto implementation"})
        map('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts, {desc = "LSP: Goto typedef"})
        map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts, {desc = "LSP: References"})
        map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts, {desc = "LSP: Signature help"})
        map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts, {desc = "LSP: Help"})
        map({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts, {desc = "LSP: Format buffer"})
    end
})

require('lspconfig').ols.setup({})

-------------------------
-- ----- OPTIONS ----- --
-------------------------

local set = vim.opt

if vim.fn.has("win32") == 1 then vim.cmd([[language en_US]]) end

-- set.showcmd = true -- Show (partial) command in status line
set.showmode = false
set.showmatch = true -- Show matching brackets
set.matchtime = 3 -- Set matching brackets time
set.cmdheight = 1
set.cmdwinheight = 10

set.autowrite = true -- Automatically save when editing multiple files
set.hidden = true -- Hide buffers when they are abandoned
set.encoding = "utf-8"
set.pumheight = 10 -- Pop-up menu height

set.scrolloff = 10
set.number = true -- Show line numbers
set.signcolumn = "yes"
set.cursorline = true -- Highlight cursorline
set.splitbelow = true
set.splitright = true
set.linebreak = true

set.mouse = "a"
set.swapfile = false
set.clipboard = "unnamedplus"

-- Langmap --
local function escape(str)
  -- You need to escape these characters to work correctly
  local escape_chars = [[;,."|\]]
  return vim.fn.escape(str, escape_chars)
end

-- Recommended to use lua template string
local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

vim.opt.langmap = vim.fn.join({
    -- | `to` should be first     | `from` should be second
    escape(ru_shift) .. ';' .. escape(en_shift),
    escape(ru) .. ';' .. escape(en),
}, ',')
-- ----- Enable folding ----- --

set.foldmethod = "indent"
set.foldlevel = 256
set.conceallevel = 1

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
set.completeopt = "menuone,noselect,preview"
set.inccommand = "split"

-------------------------
-- ----- REQUIRE ----- --
-------------------------

-------------------------
-- ----- KEYMAPS ----- --
-------------------------
local map = vim.keymap.set

map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

map("n", "<leader>l", ":nohl<CR>", { silent = true, desc = "Clear search highlight" })
map("n", "<leader>ec", ":e $MYVIMRC<CR>", { silent = true, desc = "Edit init.lua" })
map("n", "<leader>ee", ":Neotree toggle<CR>", { silent = true , desc = "Toggle Neotree"})

map("n", "<leader>mf", ":ObsidianFollowLink<CR>", { silent = true })

map('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { expr = true })
map('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

map("n", "<C-S>", ":w<CR>")
map("n", "<leader>cd", ":cd %:h<CR>", { desc = "Change dir to current file"} )
map("n", "<leader>cc", ":Compile<CR>", { desc = "Compile Mode" })

map("n", "<leader>i", "<C-I>", { silent = true, desc = "Jump forward" })
map("n", "<leader>o", "<C-O>", { silent = true, desc = "Jump back" })
map("n", "<leader>v", "<C-V>", { silent = true, desc = "Enter visual block mode" })

-- Remap for dealing with word wrap
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

map({ "n", "x", "o" }, "H", "^")
map({ "n", "x", "o" }, "L", "$")

-- Put semicolon at the end of the line --
map("i", "<A-;>", "<Esc>miA;<Esc>`ia")

-- Telescope keybinds --
local builtin = require("telescope.builtin")
map("n", "<leader>?",       builtin.oldfiles,                  { desc = "[?] Recent files" })
map("n", "<leader><space>", builtin.buffers,                   { desc = "[ ] Open buffers" })
map("n", "<leader>/",       builtin.current_buffer_fuzzy_find, { desc = "[/] Fuzzily search in buffer]" })
map("n", "<leader>ff",      builtin.find_files,                { desc = "[F]ind [F]iles" })
map("n", "<leader>fh",      builtin.help_tags,                 { desc = "[F]ind [H]elp" })
map("n", "<leader>fw",      builtin.grep_string,               { desc = "[F]ind current [W]ord" })
map("n", "<leader>fg",      builtin.live_grep,                 { desc = "[F]ind by [G]rep" })
map("n", "<leader>fj",      builtin.jumplist,                  { desc = "[F]ind in [J]umplist" })
map("n", "<leader>fd",      builtin.diagnostics,               { desc = "[F]ind [D]iagnostics" })

-- Spectre (search and replace) --
map('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
map('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word"
})
map('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word"
})

-- Diagnostic keymaps --
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)
map("n", "<leader>k", vim.diagnostic.open_float, { desc = "Open diagnostics" })

-- Buffers --
map("n", "gp", ":bprevious<CR>")
map("n", "gn", ":bnext<CR>")

-- Window movement --
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-j>", "<C-w>j")

-- Increment/Decrement --
map("n", "<leader>a", "<C-a>", { desc = "Increment" })
map("n", "<leader>x", "<C-x>", { desc = "Decrement" })

-- insert en_US symbols from russian keyboard --
map("n", "<leader>2", "i@<esc>", { desc = "Insert @" })
map("n", "<leader>3", "i#<esc>", { desc = "Insert #" })
map("n", "<leader>4", "i$<esc>", { desc = "Insert $" })
map("n", "<leader>7", "i&<esc>", { desc = "Insert &" })
map("i", "<A-2>", "@")
map("i", "<A-3>", "#")
map("i", "<A-4>", "$")
map("i", "<A-7>", "&")

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

-- [[ Open scratch buffer by default ]]
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  pattern = "{}",
  callback = function()
    if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
      vim.bo.buftype = "nofile"
      vim.bo.bufhidden = "wipe"
    end
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
vim.cmd("autocmd FileType odin set expandtab ts=4 shiftwidth=4 softtabstop=4")
vim.cmd("autocmd FileType go set expandtab ts=4 shiftwidth=4 softtabstop=4")
vim.cmd("autocmd FileType html,css set expandtab ts=2 shiftwidth=2 softtabstop=2")
vim.cmd("autocmd FileType typ set expandtab ts=2 shiftwidth=2 softtabstop=2 nu linebreak")

if vim.g.nvy then
    vim.o.guifont = "Iosevka Nerd Font:h13"
    map({"n", "i", "v"}, "<C-S-v>", "<C-R>+")
end

if vim.g.neovide then
    vim.o.guifont = "Iosevka Nerd Font:h13"
    vim.keymap.set({"n", "i", "v"}, "<C-S-v>", "<C-R>+")
    vim.g.neovide_scroll_animation_length = 0.2
    vim.g.neovide_cursor_trail_size = 0.2
end
-- require('langmapper').automapping({ global = true, buffer = true })
