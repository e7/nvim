local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

-- lazy.nvim管理其它插件
require("lazy").setup({
    -- file explorer
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup {}
        end,
    },
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},

    -- telescope
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        cmd = 'Telescope',  -- 只有在执行 :Telescope 命令时加载
        config = function()
          require('telescope').setup{
            defaults = {
              file_ignore_patterns = {"node_modules", ".git"},
            },
          }
        end
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make', -- 如果没有编译，可以到插件扩展目录手动make
        config = function()
          require('telescope').load_extension('fzf')
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPost', 'BufNewFile' },
        cmd = { 'LspInfo', 'LspInstall', 'LspUninstall' },
        dependencies = {
            {'rmagatti/goto-preview', event = 'VeryLazy' },
        },
        config = function()
            -- lua配置
            require("lspconfig").lua_ls.setup({})
            -- pyright配置
            require('lspconfig').pyright.setup{}

            -- gopls配置
            require("lspconfig").gopls.setup({
                settings = {
                    ui = {
                        completion = {
                            usePlaceholders = true,
                        },
                    },
                    gopls = {
                        analyses = {
                            unusedparams = true,
                        },
                    -- 启用静态检查
                    staticcheck = true,
                  },
                },
            })

        end
    },
    {
        "hrsh7th/nvim-cmp",
        config = function()
            local cmp = require('cmp')

          -- 设置 nvim-cmp 补全行为
          cmp.setup({
            snippet = {
              expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
              end,
            },
            mapping = {
                ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ['<Tab>'] = cmp.mapping.confirm({ select = true }),
            },
            sources = {
              { name = 'nvim_lsp' },
              { name = 'buffer' },
              { name = 'path' },
            },
          })
        end,
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "cmp-nvim-lsp",
            "cmp_luasnip",
            "cmp-buffer",
            "cmp-path",
            "cmp-cmdline",
        },
    },
    { "hrsh7th/cmp-nvim-lsp", lazy = true },
    { "saadparwaiz1/cmp_luasnip", lazy = true },
    { "hrsh7th/cmp-buffer", lazy = true },
    { "hrsh7th/cmp-path", lazy = true },
    { "hrsh7th/cmp-cmdline",lazy = true },
    {
        -- mason不是必须的，但它能帮你更好的安装和管理LSP服务器
        'williamboman/mason.nvim',
        opts = {
            pip = {
                upgrade_pip = false,
                install_args = pip_args,
            },
            ui = {
                border = 'single',
                width = 0.7,
                height = 0.7,
            },
        }
    },
})
