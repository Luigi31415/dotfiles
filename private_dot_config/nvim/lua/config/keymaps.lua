-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local modes = { "n", "i", "v", "c", "t" }

-- I sometimes mistakenly press q and that starts recording a macro and messes up my other keymaps
map("n", "Q", "q", { noremap = true })

-- I want to always center cursor on screen after going up and down
map("n", "<C-D>", "<C-D>zz", { noremap = true, silent = true })
map("n", "<C-U>", "<C-U>zz", { noremap = true, silent = true })
-- for _, mode in ipairs(modes) do
--   vim.api.nvim_set_keymap(mode, "<C-s>", ":w<CR>", { noremap = true, silent = true })
-- end
--

-- vim.keymap.set("n", "<S-A-1>", function()
--   vim.notify("Your custom popup message here!", vim.log.levels.INFO)
-- end, { desc = "Show popup message" })
--
--
