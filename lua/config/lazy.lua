-- Considerations:
-- Removed all trailing .nvim form plugins names
-- All trailing .<value> in plugin name replaced with -<value>

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- General options

vim.opt.scrolloff = 5

vim.cmd("set number")
vim.cmd("set relativenumber")
vim.cmd("set shiftwidth=4")
vim.cmd("set tabstop=4")
vim.cmd("set nohls")
vim.cmd("set nowrap")
vim.cmd("set expandtab")
vim.cmd("set mousescroll=ver:1,hor:2")

-- Manual folding
vim.o.foldcolumn = "1" -- '0' is not bad
vim.cmd([[
	set foldtext=substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend))
]])
vim.wo.foldmethod = "manual"
vim.wo.fillchars = "fold: "
vim.wo.foldnestmax = 3
vim.wo.foldminlines = 1

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    import = "plugins",
  },
  -- Try to load one of these colorschemes when starting an installation during startup
  install = { colorscheme = { "catppuccin-mocha", "darcula-solid" } },
  -- Automatically check for plugin updates
  checker = { enabled = false },
  defaults = {
    lazy = false,
    version = nil,
  },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = false,
    notify = true, -- get a notification when changes are found
  },
})
require("config.keymap")
require("config.neovide")
require("config.tabwidth")
require("config.filetype")
