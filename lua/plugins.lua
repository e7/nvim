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
})
