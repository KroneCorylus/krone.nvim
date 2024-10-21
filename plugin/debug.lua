messagesvs = function()
  require("bmessages").toggle({ split_type = "vsplit", split_size_vsplit = 60, split_direction = "botright" })
end


vim.api.nvim_create_user_command('Messagesvs', messagesvs, {})
