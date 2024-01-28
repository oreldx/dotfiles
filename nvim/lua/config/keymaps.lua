-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

local discipline = require("orel.discipline")
discipline.cowboy()

-- Increment/Decrement (numbers)
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

keymap.set("n", "dp", ":%s/\r//g", opts)

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Tab handler
keymap.set("n", "<C-t>t", ":tabedit<CR>", opts)
keymap.set("n", "<C-t><Tab>", ":tabnext<CR>", opts)
keymap.set("n", "<C-t><S-Tab>", ":tabprevious<CR>", opts)
keymap.set("n", "<C-t>w", ":tabclose<CR>", opts)
