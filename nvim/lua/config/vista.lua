--
-- vista.lua
-- Vista specifc configuration
--
local vim = vim

local vista = {}

function vista.init()
    vim.cmd("packadd vista.vim")
    vista.config()
end

function vista.config()
    vim.g["vista#renderer#enable_icons"] = 1
    vim.g.vista_sidebar_width = 50
    vim.g.vista_icon_indent = {"╰─▸ ", "├─▸ "}
    vim.g.vista_default_executive = "nvim_lsp"
    vim.g.vista_executive_for = {
        vimwiki = "markdown",
        pandoc = "markdown",
        markdown = "toc",
        terraform = "nvim_lsp",
        rust = "nvim_lsp",
        lua = "nvim_lsp",
        python = "nvim_lsp"
    }
end

return vista
