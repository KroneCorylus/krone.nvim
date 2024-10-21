-- Open file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
--idk
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '>-2<CR>gv=gv")



--InvokeAI
vim.keymap.set({ 'v', 'n' }, '<F5>', function()
  vim.cmd(":w")
  vim.cmd("messages clear")
  require("invokeai").reset()
end, { silent = true })

vim.keymap.set('v', '<Leader>ia', function()
  require('invokeai').popup()
end, { silent = true, desc = "Ask IA and get response in floating window" })

vim.keymap.set('v', '<Leader>ib', function()
  require('invokeai').popup({ resolve_fn = require("invokeai.resolvers.replace") })
end, { silent = true, desc = "Ask IA as replace" })

vim.keymap.set('v', '<Leader>it', function()
  require('invokeai').pre_prompt(
    "add the correct type annotations and if the language allow it and some arguments are checked for nulish, remember to set that can be nulish on the types",
    { resolve_fn = require("invokeai.resolvers.replace") })
end, { silent = true, desc = "Add types" })

vim.keymap.set('v', '<Leader>il', function()
  require('invokeai').pre_prompt("only add type annotations in LuaCATS format",
    { resolve_fn = require("invokeai.resolvers.replace") })
end, { silent = true, desc = "Add types lua" })
