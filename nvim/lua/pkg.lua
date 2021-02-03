--
-- pkg.lua
-- Package Management
--
local vim = vim
local call_fn = vim.api.nvim_call_function

local pkg = {
    packages = {
        {"neovim/nvim-lspconfig"}, {"nvim-treesitter/nvim-treesitter"},
        {"romgrk/nvim-treesitter-context"}, {"romgrk/barbar.nvim"},
        {"tpope/vim-dispatch"}, {"tpope/vim-commentary"},
        {"tpope/vim-surround"}, {"townk/vim-autoclose"},
        {"AndrewRadev/splitjoin.vim"}, {"honza/vim-snippets"},
        {"itchyny/lightline.vim"}, {"kaicataldo/material.vim"},
        {"nvim-lua/completion-nvim"}, {"ncm2/float-preview.nvim"},
        {"pechorin/any-jump.nvim"}, {"kristijanhusak/defx-icons"},
        {"ryanoasis/vim-devicons"}, {"liuchengxu/vista.vim"},
        {"tjdevries/nlua.nvim"}, {"kyazdani42/nvim-web-devicons"},
	{"elixir-editors/vim-elixir"}, {"slashmili/alchemist.vim"},
        {"fatih/vim-go", {["type"] = "opt"}},
        {"k-takata/minpac", {["type"] = "opt"}},
        {"vimwiki/vimwiki", {["type"] = "opt"}},
        {"ayu-theme/ayu-vim", {["type"] = "opt"}},
        {"tpope/vim-fugitive", {["type"] = "opt"}},
        {"mhinz/vim-startify", {["type"] = "opt"}},
        {"rust-lang/rust.vim", {["type"] = "opt"}},
        {"mitsuhiko/vim-jinja", {["type"] = "opt"}},
        {"hashivim/vim-terraform", {["type"] = "opt"}},
        {"puremourning/vimspector", {["type"] = "opt"}},
        {
            "Shougo/defx.nvim",
            {["do"] = ":UpdateRemotePlugins", ["type"] = "opt"}
        },
        {
            "liuchengxu/vim-clap", {["type"] = "opt"},
            {["do"] = ":Clap install-binary"}
        }
    }
}

function pkg.init()
    if not vim.g.minpac_is_init then
        vim.cmd("packadd minpac")

        call_fn("minpac#init", {})

        for _, p in ipairs(pkg.packages) do call_fn('minpac#add', p) end

        vim.cmd("packadd nvim-treesitter")
        vim.cmd("packadd material.vim")
        vim.cmd("packadd vim-startify")
        vim.cmd("packadd nvim-web-devicons")
        vim.cmd("packadd barbar.nvim")
        vim.cmd("packadd vista.vim")
        vim.cmd("packadd vimwiki")
        vim.cmd("packadd vim-clap")

        vim.cmd([[command! PackUpdate lua require("pkg").packUpdate()]])
        vim.cmd([[command! PackClean  lua require("pkg").packClean()]])
        vim.cmd([[command! PackStatus lua require("pkg").packStatus()]])

        require("config.treesitter").init()
        require("config.startify").init()

        vim.g.minpac_is_init = true
    end
end

function pkg.packUpdate()
    pkg.init()
    call_fn("minpac#update", {""})
    vim.cmd("LspInstall dockerls")
    vim.cmd("LspInstall vimls")
    vim.cmd("LspInstall pyls_ms")
    vim.cmd("LspInstall jsonls")
    vim.cmd("TSUpdate")
end

function pkg.packClean()
    pkg.init()
    call_fn("minpac#clean", {})
end

function pkg.packStatus()
    pkg.init()
    call_fn("minpac#status", {})
end

return pkg
