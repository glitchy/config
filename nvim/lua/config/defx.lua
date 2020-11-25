--
-- defx.lua
-- Defx specifc configuration
--
local vim = vim
local buf_set_keymap = vim.api.nvim_buf_set_keymap
local set_keymap = vim.api.nvim_set_keymap

local keymaps = require("keymaps")
local defx = {}

function defx.init()
    vim.cmd("packadd defx.nvim")
    set_keymap("n", "<C-f>",
               ":Defx -columns=icons:indent:filename:type -split=vertical -winwidth=40 -direction=topleft -toggle<CR>",
               {silent = true, noremap = true})
    defx.config()
end

function defx.config()
    vim.g.defx_icons_enable_syntax_highlight = 1
    vim.g.defx_icons_column_length = 2
    vim.g.defx_icons_directory_icon = ""
    vim.g.defx_icons_mark_icon = "*"
    vim.g.defx_icons_parent_icon = ""
    vim.g.defx_icons_default_icon = ""
    vim.g.defx_icons_directory_symlink_icon = ""
    vim.g.defx_icons_root_opened_tree_icon = ""
    vim.g.defx_icons_nested_opened_tree_icon = ""
    vim.g.defx_icons_nested_closed_tree_icon = ""
end

function defx.keymaps()
    buf_set_keymap(0, "n", "<CR>", [[defx#do_action("drop")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "c", [[defx#do_action("copy")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "m", [[defx#do_action("move")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "p", [[defx#do_action("drop", "paste")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "l", [[defx#do_action("drop", "open")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "E", [[defx#do_action("drop", "vsplit")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "P", [[defx#do_action("drop", "pdeit")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "o", [[defx#do_action("open_or_close_tree")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "K", [[defx#do_action("new_directory")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "N", [[defx#do_action("new_file")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "M", [[defx#do_action("new_multiple_files")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "C",
                   [[defx#do_action("toggle_columns", "mark:indent:icon:filename:type:size:time")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "S", [[defx#do_action("toggle_sort", "time")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "d", [[defx#do_action("remove")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "r", [[defx#do_action("rename")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "!", [[defx#do_action("execute_command")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "x", [[defx#do_action("execute_system")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "yy", [[defx#do_action("yank_path")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", ".", [[defx#do_action("toggle_ignored_files")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", ";", [[defx#do_action("repeat")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "h", [[defx#do_action("cd", [".."])]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "~", [[defx#do_action("cd")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "q", [[defx#do_action("quit")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", " ", [[defx#do_action("toggle_select") . "j"]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "*", [[defx#do_action("toggle_select_all")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "j", [[line(".") == line("$") ? "gg" : "j"]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "k", [[line(".") == 1 ? "G" : "k"]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "<C-g>", [[defx#do_action("print")]],
                   {silent = true, noremap = true, expr = true})
    buf_set_keymap(0, "n", "cd", [[defx#do_action("change_vim_cwd")]],
                   {silent = true, noremap = true, expr = true})

    keymaps.navigation()
end

return defx
