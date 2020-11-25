--
-- lsp.lua
-- Configuration information for nvim-lsp
--
local vim = vim
local set_keymap = vim.api.nvim_set_keymap

vim.cmd("packadd nvim-lsp")

local lsp = {
    nvim_lsp = require("nvim_lsp"),
    callbacks = require("config/lsp_callbacks")
}

function lsp.init()
    lsp.nvim_lsp.clangd.setup({})
    lsp.nvim_lsp.dockerls.setup({})
    lsp.nvim_lsp.jsonls.setup({})
    lsp.nvim_lsp.pyls_ms.setup({})
    lsp.nvim_lsp.rust_analyzer.setup({})
    lsp.nvim_lsp.sumneko_lua.setup({})
    lsp.nvim_lsp.terraformls.setup({})
    lsp.nvim_lsp.vimls.setup({})

    lsp.keymaps()
    lsp.set_signs()

    vim.lsp.callbacks["textDocument/publishDiagnostics"] =
        lsp.callbacks.diagnostics_callback
    vim.lsp.callbacks["textDocument/hover"] = lsp.callbacks.hover_callback

    vim.cmd("autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif")
end

function lsp.set_signs()
    vim.cmd("sign define LspDiagnosticsErrorSign text= ")
    vim.cmd("sign define LspDiagnosticsWarningSign text= ")
    vim.cmd("sign define LspDiagnosticsInformationSign text= ")
    vim.cmd("sign define LspDiagnosticsHintSign text=")
    vim.cmd("hi LspDiagnosticsHint guifg=#82aafe")
    vim.cmd("hi LspDiagnosticsWarning guifg=#ffcb6b")
    vim.cmd("hi LspDiagnosticsError guifg=#f07178")
    vim.cmd("hi LspDiagnosticsInformtion guifg=#c3e88d")
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
