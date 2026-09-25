---
name: neovim-config
description: "Use when you need help with Neovim configuration, plugin development, Lua scripting, creating custom plugins, or troubleshooting Neovim setups. Also use for configuring LSP, treesitter, completion engines, keybindings, or Neovim-based workflows."
---

# Neovim Configuration & Plugin Development

## Overview

This skill provides expert guidance for configuring Neovim and developing personal plugins. It covers Lua configuration, plugin management, LSP setup, treesitter configuration, keybindings, custom plugin development, and best practices for maintainable Neovim setups.

## When to Use

Invoke this skill when:
- Setting up a new Neovim configuration
- Migrating from Vimscript to Lua
- Configuring or troubleshooting plugins
- Developing custom Neovim plugins
- Setting up LSP, completion, or syntax highlighting
- Optimizing Neovim performance
- Creating keybindings and mappings
- Debugging Neovim issues
- Configuring terminal integration or tmux

## Prerequisites

- Neovim 0.9+ (0.10+ recommended for latest features)
- Basic understanding of Lua (Lua 5.1 for Neovim)
- Familiarity with Neovim's init.lua structure

## Core Concepts

### Configuration Structure

```
~/.config/nvim/
├── init.lua                    # Main entry point
├── lua/
│   ├── config/                 # Configuration modules
│   │   ├── options.lua         # Vim options
│   │   ├── keymaps.lua         # Key mappings
│   │   ├── lazy.lua            # Plugin manager setup
│   │   └── autocmds.lua        # Autocommands
│   └── plugins/                # Plugin specifications
│       ├── init.lua            # Plugin list
│       ├── lsp.lua             # LSP configuration
│       ├── treesitter.lua      # Treesitter config
│       └── custom/             # Your custom plugins
└── after/
    └── ftplugin/               # Filetype-specific settings
```

### Plugin Managers

**Lazy.nvim** (Recommended):
```lua
-- lua/config/lazy.lua
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins')
```

## Workflow: Basic Configuration

### Step 1: Set Up Options

```lua
-- lua/config/options.lua
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 50
vim.opt.colorcolumn = '80'
```

### Step 2: Configure Keymaps

```lua
-- lua/config/keymaps.lua
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })

-- File explore
vim.keymap.set('n', '<leader>e', ':Explore<CR>', { desc = 'Open file explore' })

-- Buffer management
vim.keymap.set('n', '<leader>bn', ':bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', ':bprev<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete buffer' })

-- Clear search highlighting
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>', { desc = 'Clear highlights' })

-- Move lines up/down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
```

### Step 3: Set Up Essential Plugins

```lua
-- lua/plugins/init.lua
return {
  -- Colorscheme
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('tokyonight')
    end,
  },
  
  -- File explore
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = true,
  },
  
  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
      { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Live grep' },
      { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Find buffers' },
    },
  },
  
  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = true,
  },
  
  -- Git integration
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'G' },
  },
}
```

### Step 4: Configure LSP

```lua
-- lua/plugins/lsp.lua
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    require('mason').setup()
    require('mason-lspconfig').setup({
      ensure_installed = { 'lua_ls', 'pyright', 'tsserver' },
    })
    
    local lspconfig = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    
    -- Setup handlers for installed servers
    require('mason-lspconfig').setup_handlers({
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,
      -- Custom configuration for specific servers
      ['lua_ls'] = function()
        lspconfig.lua_ls.setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = { globals = { 'vim' } },
              workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
              },
            },
          },
        })
      end,
    })
    
    -- Keymaps
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local opts = { buffer = args.buf }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      end,
    })
  end,
}
```

### Step 5: Configure Completion

```lua
-- lua/plugins/completion.lua
return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lsp',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    
    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expandable() then
            luasnip.expand()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
      }),
    })
  end,
}
```

## Workflow: Custom Plugin Development

### Step 1: Create Plugin Structure

```
~/.config/nvim/lua/custom/my-plugin/
├── init.lua           # Main plugin entry
├── config.lua         # Configuration module
├── core.lua           # Core functionality
└── utils.lua          # Utility functions
```

### Step 2: Write the Main Plugin File

```lua
-- ~/.config/nvim/lua/custom/my-plugin/init.lua
local M = {}

-- Default configuration
M.config = {
  enabled = true,
  highlight_color = '#FF6B6B',
  max_results = 10,
}

-- Setup function (called by user)
function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
  
  -- Create autocommands
  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = '*.lua',
    callback = function()
      if M.config.enabled then
        M.on_save()
      end
    end,
  })
  
  -- Create user commands
  vim.api.nvim_create_user_command('MyPluginToggle', function()
    M.config.enabled = not M.config.enabled
    print('MyPlugin: ' .. (M.config.enabled and 'enabled' or 'disabled'))
  end, {})
  
  -- Set up keymaps
  vim.keymap.set('n', '<leader>mp', function()
    M.show_results()
  end, { desc = 'Show MyPlugin results' })
end

-- Core functionality
function M.on_save()
  -- Your plugin logic here
  print('File saved! Running custom logic...')
end

function M.show_results()
  -- Create a floating window to show results
  local buf = vim.api.nvim_create_buf(false, true)
  
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)
  
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
    title = ' MyPlugin Results ',
    title_pos = 'center',
  }
  
  local win = vim.api.nvim_open_win(buf, true, opts)
  
  -- Add content to buffer
  local lines = {
    'MyPlugin Results',
    string.rep('=', 40),
    '',
    'Configuration:',
    '  Enabled: ' .. tostring(M.config.enabled),
    '  Highlight Color: ' .. M.config.highlight_color,
    '  Max Results: ' .. M.config.max_results,
  }
  
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  
  -- Close on 'q' or Esc
  vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, silent = true })
  vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = buf, silent = true })
end

return M
```

### Step 3: Create Plugin Specification

```lua
-- ~/.config/nvim/lua/plugins/my-custom-plugin.lua
return {
  dir = vim.fn.stdpath('config') .. '/lua/custom/my-plugin',
  name = 'my-plugin',
  config = function()
    require('custom.my-plugin').setup({
      enabled = true,
      highlight_color = '#4ECDC4',
      max_results = 20,
    })
  end,
  -- Or for external plugins (if published)
  -- 'yourusername/my-plugin.nvim',
  -- config = function()
  --   require('my-plugin').setup({})
  -- end,
}
```

### Step 4: Loading Your Plugin

If using lazy.nvim, the plugin will be automatically loaded from the `lua/plugins/` directory. To load from custom directory without lazy:

```lua
-- In init.lua, after lazy setup
require('custom.my-plugin').setup({
  enabled = true,
})
```

## Advanced Topics

### Treesitter Configuration

```lua
-- lua/plugins/treesitter.lua
return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = {
        'lua', 'python', 'javascript', 'typescript',
        'json', 'yaml', 'toml', 'markdown',
      },
      sync_install = false,
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = '<C-s>',
          node_decremental = '<C-backspace>',
        },
      },
    })
  end,
}
```

### Custom Autocommands

```lua
-- lua/config/autocmds.lua
local augroup = vim.api.nvim_create_augroup('CustomAutocmds', { clear = true })

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
  end,
})

-- Auto-resize splits when terminal is resized
vim.api.nvim_create_autocmd('VimResized', {
  group = augroup,
  command = 'wincmd =',
})

-- Set filetype-specific options
vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = { 'lua', 'python' },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})
```

### Performance Optimization

```lua
-- lua/config/options.lua - Performance settings

-- Reduce update time
vim.opt.updatetime = 250

-- Optimize for large files
vim.opt.maxmempattern = 5000
vim.opt.synmaxcol = 200

-- Disable built-in plugins you don't use
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_remote_plugins = 1
```

## Troubleshooting

### Common Issues

1. **Plugin not loading**: Check lazy.nvim spec, ensure `dir` or `name` is correct
2. **LSP not attaching**: Verify filetype, ensure server is installed with Mason
3. **Keymaps not working**: Check for conflicts, use `vim.keymap.set` not `vim.api.nvim_set_keymap`
4. **Colors not showing**: Ensure `termguicolors` is set
5. **Slow startup**: Profile with `nvim --startuptime startup.log`

### Debugging Your Plugin

```lua
-- Add to your plugin for debugging
function M.debug(msg)
  if vim.g.my_plugin_debug then
    vim.notify('MyPlugin: ' .. tostring(msg), vim.log.levels.DEBUG)
  end
end

-- Enable debugging
vim.g.my_plugin_debug = true
```

## Best Practices

1. **Use Lua, not Vimscript**: Lua is faster and more maintainable
2. **Lazy-load plugins**: Only load when needed using lazy.nvim keys, cmd, ft, or event triggers
3. **Modular structure**: Separate concerns (options, keymaps, plugins, LSP)
4. **Version pin plugins**: Specify commit or version for stability
5. **Document keymaps**: Use `{ desc = '...' }` in all keymap definitions
6. **Use built-in API**: Prefer `vim.api` and `vim.fn` over external libraries
7. **Test changes**: Use `nvim --clean` to test without config
8. **Keep backups**: Use git to version control your config

## Examples

### Input: "Create a plugin that shows word count on save"

```lua
-- lua/custom/wordcount/init.lua
local M = {}

function M.setup(opts)
  opts = opts or {}
  local min_word_count = opts.min_word_count or 100
  
  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = '*.md,*.txt,*.tex',
    callback = function(args)
      local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
      local text = table.concat(lines, ' ')
      local word_count = select(2, text:gsub('%S+', ''))
      
      if word_count >= min_word_count then
die_notify(
          string.format('Word count: %d', word_count),
          vim.log.levels.INFO,
          { title = 'Word Counter' }
        )
      end
    end,
  })
end

return M
```

### Input: "Set up Neovim for Python development"

Follow the LSP and completion workflows above, then add:
```lua
-- Ensure Python LSP is installed
require('mason-lspconfig').setup({
  ensure_installed = { 'pyright', 'ruff_lsp' },
})

-- Python-specific settings
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.colorcolumn = '88'  -- PEP 8 recommends 79, Black uses 88
  end,
})
```

## References

- Neovim Lua API: https://neovim.io/doc/user/lua.html
- Lazy.nvim docs: https://github.com/folke/lazy.nvim
- nvim-lspconfig: https://github.com/neovim/nvim-lspconfig
- nvim-treesitter: https://github.com/nvim-treesitter/nvim-treesitter
- Lua 5.1 Reference: https://www.lua.org/manual/5.1/

## Output Format

When helping with Neovim configuration, provide:
1. Clear file paths for each code block
2. Complete, working code examples
3. Explanation of what each section does
4. Integration instructions (where to place files)
5. Prerequisites and dependencies
6. Testing steps to verify the configuration works
