--
-- lsp.lua
-- Configuration information for nvim-lsp
--
local vim = vim
local set_keymap = vim.api.nvim_set_keymap

vim.cmd("packadd completion-nvim")

local lsp = {
    configs = require("lspconfig"),
    callbacks = require("config/lsp_callbacks")
}

function lsp.init()
    vim.cmd("autocmd! BufEnter * lua require('completion').on_attach()")
    vim.cmd([[inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"]])
    vim.cmd([[inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"]])
    vim.cmd([[set completeopt=menuone,noinsert,noselect]])
    vim.cmd([[set shortmess+=c]])

    lsp.configs.clangd.setup {}
    lsp.configs.dockerls.setup {}
    lsp.configs.jsonls.setup {}
    lsp.configs.rust_analyzer.setup {}
    lsp.configs.elixirls.setup { cmd = { "/Users/lukasjorgensen/.config/elixir-ls/language_server.sh" } }
    -- lsp.configs.sumneko_lua.setup {on_attach = require'completion'.on_attach}
    lsp.configs.terraformls.setup {}
    lsp.configs.vimls.setup {}
    lsp.configs.gopls.setup {}

    lsp.keymaps()
    lsp.set_signs()

    vim.lsp.callbacks["textDocument/publishDiagnostics"] =
        lsp.callbacks.diagnostics_callback
    vim.lsp.callbacks["textDocument/hover"] = lsp.callbacks.hover_callback

    vim.cmd("autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif")
end

function lsp.set_signs()
    vim.cmd("highlight LspDiagnosticsDefaultHint guifg=#82aafe")
    vim.cmd("highlight LspDiagnosticsDefaultWarning guifg=#ffcb6b")
    vim.cmd("highlight LspDiagnosticsDefaultError guifg=#f07178")
    vim.cmd("highlight LspDiagnosticsDefaultInformtion guifg=#c3e88d")
    vim.cmd("sign define LspDiagnosticsSignError text= ")
    vim.cmd("sign define LspDiagnosticsSignWarning text= ")
    vim.cmd("sign define LspDiagnosticsSignInformation text= ")
    vim.cmd("sign define LspDiagnosticsSignHint text=")
end

function lsp.keymaps()
    set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.declaration()<CR>",
               {silent = true, noremap = true})
    set_keymap("n", "<C-]>", "<cmd>lua vim.lsp.buf.definition()<CR>",
               {silent = true, noremap = true})
    set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>",
               {silent = true, noremap = true})
    set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.implementation()<CR>",
               {silent = true, noremap = true})
    set_keymap("n", "<C-S-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>",
               {silent = true, noremap = true})
    set_keymap("n", "1gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>",
               {silent = true, noremap = true})
    set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>",
               {silent = true, noremap = true})
end

return lsp
