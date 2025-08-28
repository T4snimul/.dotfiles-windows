vim.g.mapleader = " "

local keymap = vim.keymap.set

-- Better navigation for wrapped lines
keymap("n", "j", "gj", { noremap = true, silent = true })
keymap("n", "k", "gk", { noremap = true, silent = true })

-- File Operations
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })

