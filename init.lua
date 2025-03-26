-- Bootstrap lazy.nvim
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

-- Plugin specifications
require("lazy").setup({
  -- Mason für LSP-Installationen
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },

  -- Oil.nvim
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup()
    end,
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate'
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end
  },

  -- Autocomplete
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'L3MON4D3/LuaSnip',
  'saadparwaiz1/cmp_luasnip',

  -- Themes
  'sainnhe/everforest',
  "EdenEast/nightfox.nvim",
  'folke/tokyonight.nvim',
  {
    "loctvl842/monokai-pro.nvim",
    config = function()
      require("monokai-pro").setup()
    end
  },
  "diegoulloao/neofusion.nvim",

  -- Mini plugins
  { 'echasnovski/mini.trailspace', config = function() require('mini.trailspace').setup() end },
  { 'echasnovski/mini.starter', config = function() require('mini.starter').setup() end },
  { 'echasnovski/mini.pairs', config = function() require('mini.pairs').setup() end },
  { 'echasnovski/mini.misc', config = function() require('mini.misc').setup() end },
  { 'echasnovski/mini.indentscope', config = function() require('mini.indentscope').setup() end },
  { 'echasnovski/mini.cursorword', config = function() require('mini.cursorword').setup() end },
  { 'echasnovski/mini.comment', config = function() require('mini.comment').setup() end },
  { 'echasnovski/mini.basics', config = function() require('mini.basics').setup() end },
  { 'echasnovski/mini.animate', config = function() require('mini.animate').setup() end },

  -- Lualine
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },

})


vim.cmd([[colorscheme monokai-pro-spectrum]])


-- lualine
require('lualine').setup {
	options = {
		icons_enabled = false,
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
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
local lspconfig = require 'lspconfig'
local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

if not lspconfig.ltex then
	configs.ltex = {
		default_config = {
			cmd = { "ltex-ls" },
			filetypes = { 'tex', 'bib', 'md' },
			settings = {
				ltex = {
					enabled = { "latex", "tex", "bib", "md" },
					checkFrequency = "save",
					language = "de-DE",
					diagnosticSeverity = "information",
					setenceCacheSize = 5000,
					additionalRules = {
						enablePickyRules = true,
						motherTongue = "de-DE",
					},
				}
			},
		},
	}
end
lspconfig.ltex.setup {}


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

map('t', '<C-c>', '<C-\\><C-n>', opts)
map('t', '<C-n>', '<C-c>', opts)

--ctrl-c angewöhnen für normalmodus
map('i', '<ESC>', '', opts)

-- Strg-w-Befehle im Terminal-Modus aktivieren
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('t', '<C-w>h', '<C-\\><C-n><C-w>h', opts) -- Wechsel zu linkem Fenster
vim.api.nvim_set_keymap('t', '<C-w>j', '<C-\\><C-n><C-w>j', opts) -- Wechsel zu unterem Fenster
vim.api.nvim_set_keymap('t', '<C-w>k', '<C-\\><C-n><C-w>k', opts) -- Wechsel zu oberem Fenster
vim.api.nvim_set_keymap('t', '<C-w>l', '<C-\\><C-n><C-w>l', opts) -- Wechsel zu rechtem Fenster
vim.api.nvim_set_keymap('t', '<C-w>t', '<C-\\><C-n><C-6>', opts) -- Wechsel zu rechtem Fenster
vim.api.nvim_set_keymap('n', '<C-w>t', '<C-w>t :b term<CR>i', opts) -- Wechsel zu rechtem Fenster


-- llama starten
local ollama_job_id = nil

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		ollama_job_id = vim.fn.jobstart('ollama serve')
	end
})

vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		if ollama_job_id then
			vim.fn.jobstop(ollama_job_id)
		end
	end
})
