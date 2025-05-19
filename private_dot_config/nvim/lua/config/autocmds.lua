-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd("VimLeave", {
  pattern = "/Users/hamza/personal/notes/*", -- replace with your full path
  callback = function()
    os.execute(
      'cd /Users/hamza/personal/notes && git pull && git add . && git commit --allow-empty -m "Saving: $(date +"%Y-%m-%d %H:%M:%S")" && git push'
    )
  end,
})
