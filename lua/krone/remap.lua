vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
--local function telescope_live_grep_open_files()
  --require('telescope.builtin').live_grep {
    --grep_open_files = true,
   --prompt_title = 'Live Grep in Open Files',
  --}
--end
--vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
--vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
