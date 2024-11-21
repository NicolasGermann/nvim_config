-- Packer installieren, falls noch nicht installiert
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
	vim.cmd [[packadd packer.nvim]]
end

-- packer.nvim Plugin manager configuration
require('packer').startup(function(use)
	-- Packer selbst aktualisieren
	use 'wbthomason/packer.nvim'

	-- mason.nvim für LSP-Installationen
	use {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'neovim/nvim-lspconfig',
		run = ':MasonUpdate' -- :MasonUpdate ausführen, wenn dieses Paket installiert wird
	}

	use {
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup()
		end,
	}

	-- telescope.nvim für Dateisuche und mehr
	use {
		'nvim-telescope/telescope.nvim',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	use "nvim-lua/plenary.nvim" -- don't forget to add this one if you don't have it yet!

	-- nvim-treesitter für bessere Syntaxhervorhebung
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}

	-- which-key.nvim für besseres Mapping-Menü
	use {
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			}
		end
	}



	-- nvim-cmp für Autocomplete
	use 'hrsh7th/nvim-cmp'  -- Autocompletion plugin
	use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
	use 'hrsh7th/cmp-buffer' -- Buffer source for nvim-cmp
	use 'hrsh7th/cmp-path'  -- Path source for nvim-cmp
	use 'hrsh7th/cmp-cmdline' -- Cmdline source for nvim-cmp
	use 'L3MON4D3/LuaSnip'  -- Snippets plugin
	use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
	-- themes
	use 'sainnhe/everforest'
	use "EdenEast/nightfox.nvim" -- Packer
	use 'folke/tokyonight.nvim'
	use {
		"loctvl842/monokai-pro.nvim",
		config = function()
			require("monokai-pro").setup()
		end
	}
	use { "diegoulloao/neofusion.nvim" }
	-- terminal

	use { "akinsho/toggleterm.nvim", tag = '*', config = function()
		require("toggleterm").setup()
	end }

	use { 'echasnovski/mini.trailspace', branch = 'main', config = function()
		require('mini.trailspace').setup()
	end }
	use { 'echasnovski/mini.starter', branch = 'main', config = function()
		require('mini.starter').setup()
	end }
	use { 'echasnovski/mini.pairs', branch = 'main', config = function()
		require('mini.pairs').setup()
	end }
	use { 'echasnovski/mini.misc', branch = 'main', config = function()
		require('mini.misc').setup()
	end }
	use { 'echasnovski/mini.indentscope', branch = 'main', config = function()
		require('mini.indentscope').setup()
	end }
	use { 'echasnovski/mini.cursorword', branch = 'main', config = function()
		require('mini.cursorword').setup()
	end }
	use { 'echasnovski/mini.comment', branch = 'main', config = function()
		require('mini.comment').setup()
	end }
	use { 'echasnovski/mini.basics', branch = 'main', config = function()
		require('mini.basics').setup()
	end }
	use { 'echasnovski/mini.animate', branch = 'main', config = function()
		require('mini.animate').setup()
	end }

	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true }
	}
end)


vim.cmd([[colorscheme monokai-pro-spectrum]])


-- lualine
require('lualine').setup {
	options = {
		icons_enabled = false,
		component_separators = { left = '|', right = '|' },
		section_separators = { left = '|', right = '|' },
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diagnostics' },
		lualine_c = { 'filename' },
		lualine_x = { 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
	extensions = { 'mason', 'oil' }
}
-- mason.nvim setup
require('mason').setup()
require('mason-lspconfig').setup({
	ensure_installed = {} -- Beispiel LSP-Server
})

-- LSP Konfiguration
local lspconfig = require('lspconfig')

-- telescope.nvim setup
require('telescope').setup {
	defaults = {
		-- Default Konfigurationen
	}
}

-- nvim-treesitter setup
require('nvim-treesitter.configs').setup {
	ensure_installed = {}, -- Sprachen, die installiert werden sollen
	highlight = {
		enable = true, -- false will disable the whole extension
		additional_vim_regex_highlighting = false,
	},
}

-- nvim-cmp setup
local cmp = require 'cmp'

cmp.setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = {
		['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		['<C-e>'] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}, {
		{ name = 'buffer' },
	})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())


-- Automatische Konfiguration aller installierten LSP-Server
local lspconfig = require('lspconfig')
require('mason-lspconfig').setup_handlers {
	function(server_name) -- Default handler (alle installierten Server)
		lspconfig[server_name].setup {
			capabilities = capabilities
		}
	end,
}

-- Keybindings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Leertaste als Leader-Taste setzen
vim.g.mapleader = ' '

--line counting
vim.wo.relativenumber = true

-- Telescope Funktionen unter Leertaste belegen
map('n', '<Leader>f', ':Telescope find_files<CR>', opts)
map('n', '<Leader>g', ':Telescope live_grep<CR>', opts)
map('n', '<Leader>b', ':Telescope buffers<CR>', opts)

-- LSP Funktionen unter Leertaste belegen
map('n', '<Leader>ld', ':lua vim.lsp.buf.definition()<CR>', opts)
map('n', '<Leader>lh', ':lua vim.lsp.buf.hover()<CR>', opts)
map('n', '<Leader>li', ':lua vim.lsp.buf.implementation()<CR>', opts)
map('n', '<Leader>ls', ':lua vim.lsp.buf.signature_help()<CR>', opts)
map('n', '<Leader>lr', ':lua vim.lsp.buf.references()<CR>', opts)
map('n', '<Leader>la', ':lua vim.lsp.buf.code_action()<CR>', opts)
map('n', '<Leader>le', ':lua vim.diagnostic.disable(0)<CR>', opts)
map('n', '<Leader>lE', ':lua vim.diagnostic.enable(0)<CR>', opts)
map('n', '<Leader>lf', ':lua vim.lsp.buf.format()<CR>', opts)
opts.desc = "lsp"
map('n', '<Leader>l', '', opts)
opts.desc = "save"
map('n', '<Leader>w', ':w<CR>', opts)
opts.desc = "quit"
map('n', '<Leader>q', ':q<CR>', opts)
opts.desc = "clear search"
map('n', '<Leader>cc', ':noh<CR>', opts)
opts.desc = "directory"
map('n', '<Leader>d', ':e .<CR>', opts)
opts.desc = "terminal toggle"
map('n', '<C-w>t', ':ToggleTermToggleAll<CR>', opts)
opts.desc = "terminal toggle"
map('n', '<Leader>tt', ':ToggleTermToggleAll<CR>', opts)
opts.desc = "terminal"
map('n', '<Leader>t', '', opts)
opts.desc = "terminal kill"
map('n', '<Leader>tk', ':bdelete!<CR>', opts)
opts.desc = "terminal horizontal"
map('n', '<Leader>th', ':ToggleTerm dir=./ name=term direction=horizontal<CR>', opts)
opts.desc = "terminal vertical"
map('n', '<Leader>tv', ':ToggleTerm dir=./ name=term direction=vertical<CR>', opts)
opts.desc = "terminal float"
map('n', '<Leader>tf', ':ToggleTerm dir=./ name=term direction=float<CR>', opts)

opts.desc = "open nvim config"
map('n', '<Leader>i', ':e ~/.config/nvim/init.lua<CR>', opts)

opts.desc = "kill buffer"
map('n', '<C-k>', ':bdelete!<CR>', opts)

opts.desc = "command shortcuts"
map('n', '<Leader>c', '', opts)

opts.desc = "open command buffer"
map('n', '<Leader>cb', 'q:', opts)

opts.desc = "open quickfix"
map('n', '<Leader>cf', ':copen<CR>', opts)

opts.desc = "Mason"
map('n', '<Leader>m', ':Mason<CR>', opts)

map('t', '<C-w>t', '<C-\\><C-n>:ToggleTermToggleAll<CR>', opts)
map('t', '<C-n>', '<C-\\><C-n>', opts)

-- Strg-w-Befehle im Terminal-Modus aktivieren
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('t', '<C-w>h', '<C-\\><C-n><C-w>h', opts) -- Wechsel zu linkem Fenster
vim.api.nvim_set_keymap('t', '<C-w>j', '<C-\\><C-n><C-w>j', opts) -- Wechsel zu unterem Fenster
vim.api.nvim_set_keymap('t', '<C-w>k', '<C-\\><C-n><C-w>k', opts) -- Wechsel zu oberem Fenster
vim.api.nvim_set_keymap('t', '<C-w>l', '<C-\\><C-n><C-w>l', opts) -- Wechsel zu rechtem Fenster
