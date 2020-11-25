--
-- vars.lua
-- Variables
--
local vim = vim
local vars = {}

function vars.init()
    vars.webDevIcons()

    vars.deoplete()
    vars.superTab()
    vars.utiliSnips()

    vars.rust()
    vars.terraform()
end

function vars.deoplete()
    vim.g["deoplete#enable_at_startup"] = 1
end

function vars.rust()
    vim.g.rustfmt_autosave = 1
end

function vars.superTab()
    vim.g.SuperTabDefaultCompletionType = "<C-x><C-o>"
end

function vars.terraform()
    vim.g.terraform_fmt_on_save = 1
    vim.g.terraform_align = 1
end

function vars.utiliSnips()
    vim.g.UltiSnipsExpandTrigger = "<C-j>"
end

function vars.webDevIcons()
    vim.g.webdevicons_enable = 1
end

return vars
