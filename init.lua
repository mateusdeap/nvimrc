vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.opt.relativenumber = true

require('user.keymaps')
require('user.autocmds')

local lazy = {}

function lazy.install(path)
  if not vim.loop.fs_stat(path) then
    print('Installing lazy.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path,
    })
  end
end

function lazy.setup(plugins)
  if vim.g.plugins_ready then
    return
  end

  -- You can "comment out" the line below after lazy.nvim is installed
  -- lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)

  require('lazy').setup(plugins, lazy.opts)
  vim.g.plugins_ready = true
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

lazy.setup({
	{'nvim-lualine/lualine.nvim'},
	{'nvim-lua/plenary.nvim'},
  {'nvim-treesitter/nvim-treesitter'},
	{'nvim-treesitter/nvim-treesitter-textobjects'},
	{'wellle/targets.vim'},
	{'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {}},
	{'numToStr/Comment.nvim'},
	{'nvim-telescope/telescope.nvim', tag = '0.1.5'},
	{'lewis6991/gitsigns.nvim'},
	{'williamboman/mason.nvim'},
	{'williamboman/mason-lspconfig.nvim'},
	{'neovim/nvim-lspconfig'}
})

vim.opt.termguicolors = true

require('lualine').setup({
	options = {
		icons_enabled = false,
		section_separators = '',
		component_separators = ''
	}
})

require('ibl').setup({
  enabled = true,
  scope = {
    enabled = false,
  },
  indent = {
    char = '▏',
  },
})

require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
  },
	textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      }
    },
  },
	ensure_installed = {
		'ruby',
		'elixir',
		'c',
		'lua'
	},
})

require('Comment').setup()

require('gitsigns').setup({
  signs = {
    add = {text = '▎'},
    change = {text = '▎'},
    delete = {text = '➤'},
    topdelete = {text = '➤'},
    changedelete = {text = '▎'},
  }
})

require("mason").setup()
require("mason-lspconfig").setup()
