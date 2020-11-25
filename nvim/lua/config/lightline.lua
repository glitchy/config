--
-- lightline.lua
-- Lightline specifc configuration
--
local vim = vim

local lightline = {}

function lightline.init()
    vim.cmd("packadd lightline.vim")
    lightline.config()
end

function lightline.config()
    vim.g["lightline#bufferline#filename_modifier"] = ":t"
    vim.g["lightline#bufferline#clickable"] = 1
    vim.g["lightline#bufferline#enable_devicons"] = 1
    vim.g["lightline#bufferline#unicode_symbols"] = 1
    vim.g["lightline#bufferline#show_number"] = 2
    vim.g["lightline#bufferline#unnamed"] = "[No Name]"

    vim.g.lightline = {
        active = {
            left = {{"mode", "paste"}, {"gitbranch", "filename"}}
        },
        colorscheme = "material_vim",
        separator = {left = "", right = ""},
        subseparator = {left = "", right = ""},
        component_function = {
            gitbranch = "FugitiveHead",
            filename = "LightlineFilename",
            filetype = "MyFiletype",
            fileformat = "MyFiletype",
        }
    }
end

return lightline
