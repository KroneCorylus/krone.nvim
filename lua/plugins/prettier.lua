local conf = function()
  vim.g['prettier#config#single_quote'] = 1
  --  vim.g['prettier#config#tab_width'] = 4
  vim.g['prettier#config#use_tabs'] = 'auto'
  vim.g['prettier#config#filetypes'] = {
    'javascript',
    'typescript',
    'json',
    'html',
    'css',
    'scss',
    'angular.html',
    -- Add other file types as needed
  }
end
return {
  "prettier/vim-prettier",
  config = conf
}
