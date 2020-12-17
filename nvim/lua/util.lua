--
-- util.lua
-- Common utilities to make using lua in NeoVim more palatable
--
local vim = vim
local api = vim.api
local validate = vim.validate
local floor = math.floor

local util = {}

-- util.dump(o)
-- Similar to json.dump in python returns a string representation of
-- the input object
function util.dump(o)
    if type(o) == "table" then
        local s = "{ "
        for k, v in pairs(o) do
            if type(k) ~= "number" then
                k = "\"" .. k .. "\""
            end
            s = s .. "[" .. k .. "] = " .. util.dump(v) .. ","
        end
        return s .. "} "
    else
        return tostring(o)
    end
end

-- util.create_augroups(o)
-- Create Au Groups from an input object
-- ex:
-- local autocmds = {
--     startup = {
--         {"FileType", "rust", [[setlocal omnifunc=v:lua.vim.lsp.omnifunc]]},
--         {"FileType", "json", [[syntax match Comment +\\/\\/.\\+$+]]},
--         {"FileType", "c", [[setlocal shiftwidth=4 noexpandtab]]},
--         {"FileType", "cpp", [[setlocal shiftwidth=4 noexpandtab]]},
--         {"FileType", "defx", [[lua require"config.defx".keymaps()]]}
--     }
-- }
-- require "util".create_augroups(autocmds)
function util.create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        vim.cmd("augroup " .. group_name)
        vim.cmd("autocmd!")
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten {"autocmd", def}, " ")
            vim.cmd(command)
        end
        vim.cmd("augroup END")
    end
end

-- define border colors based on Normal and NormalNC bg colors
local bg = api.nvim_get_hl_by_name("Normal", 1)["background"]
local fg = api.nvim_get_hl_by_name("NormalNC", 1)["background"]

if bg == nil then
    bg = "#000000"
end

if fg == nil then
    fg = "#000000"
end

vim.cmd("hi PopupWindowBorder guifg=" .. fg .. " guibg=" .. bg)
vim.cmd("hi InvertedPopupWindowBorder guifg=" .. bg .. " guibg=" .. fg)

local function scale_win(w, h)
    local win_width = floor(vim.fn.winwidth(0) * w)
    local win_height = floor(vim.fn.winheight(0) * h)
    return win_width, win_height
end

local function make_popup_options(width, height, opts)
    validate {opts = {opts, "t", true}}
    opts = opts or {}
    validate {
        ["opts.offset_x"] = {opts.offset_x, "n", true},
        ["opts.offset_y"] = {opts.offset_y, "n", true}
    }

    local anchor = ""
    local row, col

    local lines_above = vim.fn.winline() - 1
    local lines_below = vim.fn.winheight(0) - lines_above

    if lines_above < lines_below then
        anchor = anchor .. "N"
        height = math.min(lines_below, height)
        row = 1
    else
        anchor = anchor .. "S"
        height = math.min(lines_above, height)
        row = 0
    end

    if vim.fn.wincol() + width <= api.nvim_get_option("columns") then
        anchor = anchor .. "W"
        col = 0
    else
        anchor = anchor .. "E"
        col = 1
    end

    return {
        anchor = anchor,
        col = col + (opts.offset_x or 0),
        height = height,
        relative = "cursor",
        row = row + (opts.offset_y or 0),
        style = "minimal",
        width = width
    }
end

function util.popup_window(contents, filetype, opts, border)
    validate {
        contents = {contents, "t"},
        filetype = {filetype, "s", true},
        opts = {opts, "t", true},
        border = {border, "b", true}
    }
    opts = opts or {}
    border = border or true

    -- Trim empty lines from the end.
    contents = vim.lsp.util.trim_empty_lines(contents)

    local width = opts.width
    local height = opts.height or #contents

    if not width then
        width = 0
        for i, line in ipairs(contents) do
            -- Clean up the input and add left pad.
            line = " " .. line:gsub("\r", "")
            local line_width = vim.fn.strdisplaywidth(line)
            width = math.max(line_width, width)
            contents[i] = line
        end

        -- Add right padding of 1 each.
        width = width + 1
    end

    -- content window
    local content_buf = api.nvim_create_buf(false, true)

    api.nvim_buf_set_lines(content_buf, 0, -1, true, contents)

    if filetype then
        api.nvim_buf_set_option(content_buf, "filetype", filetype)
    end

    api.nvim_buf_set_option(content_buf, "modifiable", false)

    local content_opts = make_popup_options(width, height, opts)

    if border and content_opts.anchor == "SE" then
        content_opts.row = content_opts.row - 1
        content_opts.col = content_opts.col - 1
    elseif border and content_opts.anchor == "NE" then
        content_opts.row = content_opts.row + 1
        content_opts.col = content_opts.col - 1
    elseif border and content_opts.anchor == "NW" then
        content_opts.row = content_opts.row + 1
        content_opts.col = content_opts.col + 1
    elseif border and content_opts.anchor == "SW" then
        content_opts.row = content_opts.row - 1
        content_opts.col = content_opts.col + 1
    end

    local content_win = api.nvim_open_win(content_buf, false, content_opts)

    if filetype == "markdown" then
        api.nvim_win_set_option(content_win, "conceallevel", 2)
    end

    api.nvim_win_set_option(content_win, "winhighlight", "Normal:NormalNC")
    api.nvim_win_set_option(content_win, "cursorline", false)

    -- border window
    local border_win

    if border then
        local border_width = width + 2
        local border_height = height + 2
        local top = "▛" .. string.rep("▀", border_width - 2) .. "▜"
        local mid = "▌" .. string.rep(" ", border_width - 2) .. "▐"
        local bot = "▙" .. string.rep("▄", border_width - 2) .. "▟"
        local lines = {top}

        for i = 1, height do
            table.insert(lines, mid)
        end

        table.insert(lines, bot)

        local border_buf = api.nvim_create_buf(false, true)

        api.nvim_buf_set_lines(border_buf, 0, -1, true, lines)
        api.nvim_buf_add_highlight(border_buf, 0, "InvertedPopupWindowBorder",
                                   0, 0, -1)

        for i = 1, border_height do
            api.nvim_buf_add_highlight(border_buf, 0,
                                       "InvertedPopupWindowBorder", i, 0, -1)
        end

        api.nvim_buf_add_highlight(border_buf, 0, "InvertedPopupWindowBorder",
                                   border_height - 1, 0, -1)
        api.nvim_command("autocmd BufWipeout <buffer> exe 'bw '" .. border_buf)

        local border_opts =
            make_popup_options(border_width, border_height, opts)

        border_win = api.nvim_open_win(border_buf, false, border_opts)
        api.nvim_win_set_option(border_win, "winhighlight", "Normal:NormalNC")
        api.nvim_win_set_option(border_win, "cursorline", false)

        vim.lsp.util.close_preview_autocmd(
            {
                "CursorMoved",
                "BufHidden",
                "InsertCharPre",
                "WinLeave",
                "FocusLost"
            }, border_win)
    end

    vim.lsp.util.close_preview_autocmd({
        "CursorMoved",
        "BufHidden",
        "InsertCharPre",
        "WinLeave",
        "FocusLost"
    }, content_win)

    return content_buf, content_win
end

function util.starts_with(str, start)
    return str:sub(1, #start) == start
end

--  get decoration column with (signs + folding + number)
function util.window_decoration_columns()

    local decoration_width = 0

    -- number width
    -- Note: 'numberwidth' is only the minimal width, can be more if...
    local max_number = 0
    if vim.api.nvim_win_get_option(0, "number") then
        -- ...the buffer has many lines.
        max_number = vim.api.nvim_buf_line_count(0)
    elseif vim.api.nvim_win_get_option(0, "relativenumber") then
        -- ...the window width has more digits.
        max_number = vim.fn.winheight(0)
    end
    if max_number > 0 then
        local actual_number_width = string.len(max_number) + 1
        local number_width = vim.api.nvim_win_get_option(0, "numberwidth")
        decoration_width = decoration_width +
                               math.max(number_width, actual_number_width)
    end

    -- signs
    if vim.fn.has("signs") then
        local signcolumn = vim.api.nvim_win_get_option(0, "signcolumn")
        local signcolumn_width = 2
        if util.starts_with(signcolumn, "yes") or
            util.starts_with(signcolumn, "auto") then
            decoration_width = decoration_width + signcolumn_width
        end
    end

    -- folding
    if vim.fn.has("folding") then
        local folding_width = vim.api.nvim_win_get_option(0, "foldcolumn")
        decoration_width = decoration_width + folding_width
    end

    return decoration_width
end

return util
