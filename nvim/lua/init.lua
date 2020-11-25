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
            "FileType",
            "rust",
            [[set relativenumber | packadd rust | setlocal omnifunc=v:lua.vim.lsp.omnifunc]]
        },
        {"FileType", "json", [[syntax match Comment +\\/\\/.\\+$+]]},
        {"FileType", "c", [[setlocal shiftwidth=4 noexpandtab]]},
        {"FileType", "cpp", [[setlocal shiftwidth=4 noexpandtab]]},
        {"FileType", "defx", [[lua require("config.defx").keymaps()]]}
    }
})

vim.g["float_preview#docked"] = 0
vim.g["float_preview#max_width"] = 133
vim.g["float_preview#winhl"] = "Normal:Pmenu,NormalNC:Pmenu"
