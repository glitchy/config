local vim = vim

vim.o.filetype = "off"
vim.o.number = true
vim.o.relativenumber = true
vim.o.hidden = true
vim.o.splitright = true
vim.o.expandtab = true
vim.o.showmatch = true
vim.o.modeline = true
vim.o.autoread = true
vim.o.cmdheight = 2
vim.o.lazyredraw = true
vim.o.tabstop = 8
vim.o.shiftwidth = 4
vim.o.updatetime = 150
vim.o.modelines = 5
vim.o.laststatus = 2
vim.o.showtabline = 2
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.syntax = "on"
vim.o.backspace = "indent,eol,start"
vim.o.signcolumn = "yes"
vim.o.clipboard = "unnamed"
vim.o.mouse = "a"
vim.o.termguicolors = true
vim.o.wildmenu = true
vim.o.wildignore = vim.o.wildignore .. "*/tmp/*,*.so,*.swp,*.zip"

vim.g.python3_host_prog = "/usr/local/bin/python3"

-- Vimwiki Config
--vim.g.vimwiki_list = [{'path': '~/vimwiki/',
--                      \ 'syntax': 'markdown', 'ext': '.md'}]
--  let wiki = {}
--  let wiki.path = '~/my_wiki/'
--  let wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp'}
--  let g:vimwiki_list = [wiki]


require("pkg").init()

vim.g.material_theme_style = "palenight"
vim.cmd("colorscheme material")

require("config.vista").init()
require("config.lightline").init()
require("config.lsp").init()
require("config.defx").init()
require("keymaps").init()

vim.cmd("filetype plugin indent on")

require("util").create_augroups({
    startup = {
        {
            "FileType", "rust",
            [[set relativenumber | set number | packadd rust | setlocal omnifunc=v:lua.vim.lsp.omnifunc]]
        },
	{
            "FileType", "elixir",
            [[set relativenumber | set number | set nowrap]]
        },
	{"FileType", "vista_kind", [[lua require("config.vista").init()]]},
        {"FileType", "c", [[setlocal shiftwidth=4 noexpandtab]]},
        {"FileType", "cpp", [[setlocal shiftwidth=4 noexpandtab]]},
        {
            "FileType", "python",
            [[set relativenumber | set number | lua require("config.lsp").configs.pyls_ms.setup{}]]
        }, 
	{"FileType", "defx", [[lua require("config.defx").keymaps()]]}
    }
})

vim.g["float_preview#docked"] = 0
vim.g["float_preview#max_width"] = 133
vim.g["float_preview#winhl"] = "Normal:Pmenu,NormalNC:Pmenu"

function disable_extras()
    vim.cmd([[call nvim_win_set_option(g:float_preview#win, 'number', v:false)]])
    vim.cmd(
        [[call nvim_win_set_option(g:float_preview#win, 'relativenumber', v:false)]])
    vim.cmd(
        [[call nvim_win_set_option(g:float_preview#win, 'cursorline', v:false)]])
    vim.cmd([[call nvim_win_set_var(g:float_preview#win, 'syntax', 'on')]])
end

function check_back_space()
    local col = vim.fn.col('.') - 1
    return not col or vim.fn.getline('.')[col - 1] == [[\s]]
end

function my_file_type()
    return vim.api.nvim_exec(
               [[winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : '']],
               true)
end

function my_file_format()
    return vim.api.nvim_exec(
               [[winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : '']],
               true)
end
