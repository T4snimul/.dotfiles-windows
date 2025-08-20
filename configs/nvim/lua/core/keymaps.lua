vim.g.mapleader = " "

local keymap = vim.keymap.set

-- Better navigation
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })

