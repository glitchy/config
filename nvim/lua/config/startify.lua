--
-- startify.lua
-- Startify specifc configuration
--
local vim = vim

local startify = {}

function startify.init()
    vim.cmd("packadd vim-startify")
    startify.config()
end

function startify.config()
    vim.g.startify_files_number = 18
    vim.g.startify_session_persistence = 1

    vim.g.startify_lists = {
        {type = "dir", header = {"   Recent files"}},
        {type = "sessions", header = {"   Saved sessions"}}
    }

    vim.g.startify_custom_header = {
        "  ",
        "   ╻ ╻   ╻   ┏┳┓",
        "   ┃┏┛   ┃   ┃┃┃",
        "   ┗┛    ╹   ╹ ╹",
        "   "
    }
end

return startify
