local set_keymap = vim.api.nvim_set_keymap

local keymaps = {}

function keymaps.init()
    -- Set Leader to Spacebar
    set_keymap("", "<Space>,", "<Nop>", {silent = true, noremap = true})
    vim.g.mapleader = " "

    keymaps.barbar()
    keymaps.clap()
    keymaps.navigation()
end

function keymaps.barbar()
    -- Magic buffer-picking mode
    set_keymap("n", "<C-s>", ":BufferPick<CR>", {silent = true, noremap = true})
    -- Sort automatically by...
    set_keymap("n", "<leader>bd", ":BufferOrderByDirectory<CR>",
               {silent = true, noremap = true})
    set_keymap("n", "<leader>bl", ":BufferOrderByLanguage<CR>",
               {silent = true, noremap = true})

    -- Move to previous/next
    set_keymap("n", "≤", ":BufferPrevious<CR>",
               {silent = true, noremap = true})
    set_keymap("n", "≥", ":BufferNext<CR>", {silent = true, noremap = true})
    -- Re-order to previous/next
    set_keymap("n", "¯", ":BufferMovePrevious<CR>",
               {silent = true, noremap = true})
    set_keymap("n", "˘", ":BufferMoveNext<CR>", {silent = true, noremap = true})

    -- Goto buffer in position...
    set_keymap("n", "¡", ":BufferGoto 1<CR>", {silent = true, noremap = true})
    set_keymap("n", "™", ":BufferGoto 2<CR>", {silent = true, noremap = true})
    set_keymap("n", "£", ":BufferGoto 3<CR>", {silent = true, noremap = true})
    set_keymap("n", "¢", ":BufferGoto 4<CR>", {silent = true, noremap = true})
    set_keymap("n", "∞", ":BufferGoto 5<CR>", {silent = true, noremap = true})
    set_keymap("n", "§", ":BufferGoto 6<CR>", {silent = true, noremap = true})
    set_keymap("n", "¶", ":BufferGoto 7<CR>", {silent = true, noremap = true})
    set_keymap("n", "•", ":BufferGoto 8<CR>", {silent = true, noremap = true})
    set_keymap("n", "ª", ":BufferLast<CR>", {silent = true, noremap = true})
end

function keymaps.clap()
    set_keymap("n", "<leader><CR>", ":<C-u>Clap<CR>",
               {silent = true, noremap = true})
    set_keymap("n", "<C-p>", ":<C-u>Clap files<CR>",
               {silent = true, noremap = true})
    set_keymap("n", "<C-a>", ":<C-u>Clap buffers<CR>",
               {silent = true, noremap = true})
end

function keymaps.navigation()
    -- Pane switching
    set_keymap("n", "<C-j>", "<C-w><C-j>", {silent = true, noremap = true})
    set_keymap("n", "<C-k>", "<C-w><C-k>", {silent = true, noremap = true})
    set_keymap("n", "<C-l>", "<C-w><C-l>", {silent = true, noremap = true})
    set_keymap("n", "<C-h>", "<C-w><C-h>", {silent = true, noremap = true})

    -- Pane resizing
    set_keymap("n", "<leader>,", ":vertical resize +5<CR>",
               {silent = true, noremap = true})
    set_keymap("n", "<leader>.", ":vertical resize -5<CR>",
               {silent = true, noremap = true})
    set_keymap("n", "<leader><", ":vertical resize +10<CR>",
               {silent = true, noremap = true})
    set_keymap("n", "<leader>>", ":vertical resize -10<CR>",
               {silent = true, noremap = true})

    -- Buffer navigation
    set_keymap("n", "<leader>h", ":bp<CR>", {silent = true})
    set_keymap("n", "<leader>l", ":bn<CR>", {silent = true})

    -- jj to exit insert mode
    set_keymap("i", "jj", "<Esc>", {})

    -- Exit Term node with ESC
    set_keymap("t", "<Esc>", "<C-\\><C-N>", {noremap = true})

    set_keymap("n", "<C-t>", ":Vista!!<CR>", {silent = true, noremap = true})
end

return keymaps
