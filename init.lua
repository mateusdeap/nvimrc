vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.opt.relativenumber = true
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
vim.opt.listchars = { space = '·', tab = '->'}
vim.opt.colorcolumn="100"

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
  lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)

  require('lazy').setup(plugins, lazy.opts)
  vim.g.plugins_ready = true
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

lazy.setup({
	{'rebelot/kanagawa.nvim'},
	{'nvim-lualine/lualine.nvim'},
	{'nvim-lua/plenary.nvim'},
  {'nvim-treesitter/nvim-treesitter'},
	{'nvim-treesitter/nvim-treesitter-textobjects'},
	{'wellle/targets.vim'},
	{'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {}},
	{'numToStr/Comment.nvim'},
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {"nvim-telescope/telescope-live-grep-args.nvim"}
	},
	{'lewis6991/gitsigns.nvim'},
	{'williamboman/mason.nvim'},
	{'williamboman/mason-lspconfig.nvim'},
	{'neovim/nvim-lspconfig'},
	{'hrsh7th/nvim-cmp'},
	{'hrsh7th/cmp-nvim-lsp'},
	{'hrsh7th/cmp-path'},
	{'hrsh7th/cmp-buffer'},
	{'saadparwaiz1/cmp_luasnip'},
	{'L3MON4D3/LuaSnip'},
	{'rafamadriz/friendly-snippets'},
	{'nvim-pack/nvim-spectre'},
  -- Add nvim-tree plugin
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    config = function()
      -- disable netrw at the very start of your init.lua
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      
      -- Custom function to attach keymaps
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")
        
        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        
        -- Default mappings
        api.config.mappings.default_on_attach(bufnr)
        
        -- Custom mappings
        vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
        vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
        vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
        vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
        vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
        vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
        vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
        vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
        vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
      end
      
      require("nvim-tree").setup({
        on_attach = on_attach,
        view = {
          width = 30,
          adaptive_size = true,  -- Automatically resize based on filename length
        },
        renderer = {
          group_empty = true,    -- Group empty folders to reduce clutter
          indent_markers = {
            enable = true,       -- Show indent markers when folders are open
          },
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
            git_placement = "before",
          },
        },
        actions = {
          open_file = {
            quit_on_open = true,  -- Close tree when opening a file (prevents the issue)
            window_picker = {
              enable = true,      -- Intelligently pick which window to open in
            },
          },
        },
        filters = {
          dotfiles = false,      -- Show dotfiles
        },
        git = {
          ignore = false,        -- Don't hide gitignored files
          timeout = 500,         -- Improve git status refresh speed
        },
        filesystem_watchers = {
          enable = true,         -- Auto-refresh when files change
        },
        diagnostics = {
          enable = true,         -- Show diagnostics in the tree
          show_on_dirs = true,   -- Show diagnostics on directories
          icons = {
            hint = "⚑",
            info = "»",
            warning = "▲",
            error = "✘",
          },
        },
      })
      
      -- Replace the <leader>e keymap to use nvim-tree
      vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', {desc = 'Toggle NvimTree'})
    end,
  },
  
  -- Add bufferline for better buffer management
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "slant",
          always_show_bufferline = false,
          show_buffer_close_icons = true,
          show_close_icon = false,
          color_icons = true,
          diagnostics = "nvim_lsp",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              separator = true
            }
          },
        }
      })
      
      -- Keymaps for bufferline
      vim.keymap.set('n', '<leader>1', '<cmd>BufferLineGoToBuffer 1<cr>', {desc = 'Go to buffer 1'})
      vim.keymap.set('n', '<leader>2', '<cmd>BufferLineGoToBuffer 2<cr>', {desc = 'Go to buffer 2'})
      vim.keymap.set('n', '<leader>3', '<cmd>BufferLineGoToBuffer 3<cr>', {desc = 'Go to buffer 3'})
      vim.keymap.set('n', '<leader>4', '<cmd>BufferLineGoToBuffer 4<cr>', {desc = 'Go to buffer 4'})
      vim.keymap.set('n', '<leader>5', '<cmd>BufferLineGoToBuffer 5<cr>', {desc = 'Go to buffer 5'})
      vim.keymap.set('n', '<leader>bp', '<cmd>BufferLinePick<cr>', {desc = 'Pick buffer'})
      vim.keymap.set('n', '<leader>bc', '<cmd>BufferLinePickClose<cr>', {desc = 'Pick buffer to close'})
    end,
  },
  
  -- Add oil.nvim as an alternative file browser
  {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('oil').setup({
        default_file_explorer = false,
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-v>"] = "actions.select_vsplit",
          ["<C-s>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-r>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["g."] = "actions.toggle_hidden",
        },
        use_default_keymaps = true,
      })
      
      -- Add a keymap for oil.nvim
      vim.keymap.set('n', '<leader>o', '<cmd>Oil<cr>', {desc = 'Open Oil file browser'})
    end,
  },
})

vim.opt.termguicolors = true
require('kanagawa').setup({
	keywordStyle = { italic = false },
	background = {
		dark = 'dragon'
	}
})
vim.cmd("colorscheme kanagawa")

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
		'lua',
		'vimdoc'
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
  },
	current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  current_line_blame_formatter_opts = {
    relative_time = false,
  }
})

local telescope = require("telescope")
-- local telescope_config = require("telescope.config")
-- local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }
--
-- table.insert(vimgrep_arguments, "--hidden")
-- table.insert(vimgrep_arguments, "--glob")
-- table.insert(vimgrep_arguments, "!**/.git/*")
--
-- telescope.setup({
-- 	defaults = {
-- 		vimgrep_arguments = vimgrep_arguments,
-- 	},
-- 	pickers = {
-- 		find_files = {
-- 			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/**" },
-- 		},
-- 	},
-- })
telescope.load_extension("live_grep_args")

require("mason").setup()
require("mason-lspconfig").setup()

local lspconfig = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local util = require 'lspconfig.util'

lspconfig.lua_ls.setup({
	capabilities = lsp_capabilities,
})

lspconfig.ruby_lsp.setup({
	cmd = { 'ruby-lsp' },
	filetypes = { 'ruby' },
	root_dir = util.root_pattern('Gemfile', '.git'),
	init_options = {
		formatter = 'auto',
	},
	single_file_support = true,
})
lspconfig.elixirls.setup({
	cmd = { '/Users/mateus/.local/share/nvim/mason/packages/elixir-ls/language_server.sh' }
})
lspconfig.clangd.setup({})
lspconfig.yamlls.setup({})

require('luasnip.loaders.from_vscode').lazy_load()

local cmp = require('cmp')
local luasnip = require('luasnip')
local select_opts = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end
	},
	sources = {
		{name = 'path'},
		{name = 'nvim_lsp', keyword_length = 1},
		{name = 'buffer', keyword_length = 3},
		{name = 'luasnip', keyword_length = 2},
	},
	window = {
		documentation = cmp.config.window.bordered()
	},
	formatting = {
		fields = {'menu', 'abbr', 'kind'},
		format = function(entry, item)
			local menu_icon = {
				nvim_lsp = 'λ',
				luasnip = '⋗',
				buffer = 'Ω',
				path = '🖫',
			}

			item.menu = menu_icon[entry.source.name]
			return item
		end,
	},
	mapping = {
		['<Up>'] = cmp.mapping.select_prev_item(select_opts),
		['<Down>'] = cmp.mapping.select_next_item(select_opts),
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
		['<C-e>'] = cmp.mapping.abort(),
		['<C-y>'] = cmp.mapping.confirm({select = true}),
		['<CR>'] = cmp.mapping.confirm({select = false}),
		['<C-f>'] = cmp.mapping(function(fallback)
			if luasnip.jumpable(1) then
				luasnip.jump(1)
			else
				fallback()
			end
		end, {'i', 's'}),
		['<C-b>'] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {'i', 's'}),
		['<Tab>'] = cmp.mapping(function(fallback)
			local col = vim.fn.col('.') - 1

			if cmp.visible() then
				cmp.select_next_item(select_opts)
			elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
				fallback()
			else
				cmp.complete()
			end
		end, {'i', 's'}),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item(select_opts)
			else
				fallback()
			end
		end, {'i', 's'}),
	},
})

local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = '✘'})
sign({name = 'DiagnosticSignWarn', text = '▲'})
sign({name = 'DiagnosticSignHint', text = '⚑'})
sign({name = 'DiagnosticSignInfo', text = '»'})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = false,
  float = true,
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {border = 'rounded'}
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {border = 'rounded'}
)

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>d', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>a', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
