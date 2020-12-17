--
-- vista.lua
-- Vista specifc configuration
--
local vim = vim

vim.cmd("packadd vista.vim")
vim.cmd("packadd barbar.nvim")

local vista = {}

function vista.init() vista.config() end

function vista.config()
    vim.bo.buflisted = false
    vim.g.vista_disable_statusline = 1
    vim.g.vista_close_on_jump = 1
    vim.g["vista#renderer#enable_icons"] = 1
    vim.g.vista_default_executive = "nvim_lsp"
    vim.g.vista_executive_for = {
        vimwiki = "markdown",
        pandoc = "markdown",
        markdown = "toc",
        terraform = "nvim_lsp",
        rust = "nvim_lsp",
        lua = "nvim_lsp",
        python = "nvim_lsp",
        go = "nvim_lsp"
    }
end

return vista
