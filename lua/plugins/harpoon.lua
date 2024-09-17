local function index_of(items, element)
  local index = -1
  for i, item in ipairs(items) do
    if item == element then
      index = i
      break
    end
  end

  return index
end

local function remove_file_from_list()

  local harpoon = require("harpoon")
  local plenary = require("plenary")

  local currentFile = vim.fn.expand('%')
  local dir = vim.fn.expand('%:p:h')
  local relativeDir = plenary.path:new(dir):make_relative()

  vim.print(harpoon:list(relativeDir):display())
    harpoon:list(relativeDir):remove()
    -- harpoon:list(relativeDir):remove({value=currentFile})

end


local function list_from_folder()
  local harpoon = require("harpoon")
  local plenary = require("plenary")

  local currentFile = vim.fn.expand('%')
  local dir = vim.fn.expand('%:p:h')
  local relativeDir = plenary.path:new(dir):make_relative()

  local files = vim.fn.systemlist("ls -p " .. dir .. " | grep -v /")
  for k in pairs(files) do
    local path = relativeDir .. "/" .. files[k]
    harpoon:list(relativeDir):add({ context = { col = 0, row = 1 }, value = path })
    -- harpoon:list(relativeDir):add(path)
  end
end


local function cycle_folder_list_next()
  local harpoon = require("harpoon")
  local dir = vim.fn.expand('%:p:h')
  local plenary = require("plenary")
  local relativeDir = plenary.path:new(dir):make_relative()
  local file = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local relativeFile = plenary.path:new(file):make_relative()
  local current_index = index_of(harpoon:list(relativeDir):display(), relativeFile)
  harpoon:list(relativeDir)._index = current_index
  harpoon:list(relativeDir):next({ ui_nav_wrap = true })
end

local function cycle_folder_list_prev()
  local harpoon = require("harpoon")
  local dir = vim.fn.expand('%:p:h')
  local plenary = require("plenary")
  local relativeDir = plenary.path:new(dir):make_relative()
  local file = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local relativeFile = plenary.path:new(file):make_relative()
  local current_index = index_of(harpoon:list(relativeDir):display(), relativeFile)
  harpoon:list(relativeDir)._index = current_index
  harpoon:list(relativeDir):prev({ ui_nav_wrap = true })
end

local function show_folder_list()
  local harpoon = require("harpoon")
  local dir = vim.fn.expand('%:p:h')
  local plenary = require("plenary")
  local relativeDir = plenary.path:new(dir):make_relative()
  harpoon.ui:toggle_quick_menu(harpoon:list(relativeDir))
end

local function list_remove()
  local harpoon = require("harpoon")
  local plenary = require("plenary")
  local relativeDir = plenary.path:new(vim.fn.expand('%:p:h')):make_relative()
  local harpoonKey = harpoon.config.settings.key()
  harpoon.lists[harpoonKey][relativeDir] = nil
  harpoon.data:update(harpoonKey, relativeDir, nil)
end

local function getNextKeyValuePair(currentKey, myTable)
  local keys = {} -- Store keys in a separate table for easy iteration

  for key, _ in pairs(myTable) do
    table.insert(keys, key)
  end

  table.sort(keys) -- Sort the keys for consistent order

  local currentIndex = 1

  for i, key in ipairs(keys) do
    if key == currentKey then
      currentIndex = i
      break
    end
  end

  local nextIndex = currentIndex % #keys + 1
  local nextKey = keys[nextIndex]
  local nextValue = myTable[nextKey]

  return nextKey
end

local function next_list()
  local harpoon = require("harpoon")
  local harpoonKey = harpoon.config.settings.key();
  local plenary = require("plenary")
  local relativeDir = plenary.path:new(vim.fn.expand('%:p:h')):make_relative()
  if harpoon.lists[harpoonKey] ~= nil then
    local next_key = getNextKeyValuePair(relativeDir, harpoon.lists[harpoonKey])
    harpoon:list(next_key):select(harpoon:list(next_key)._index)
    print("Harpoon list: " .. next_key)
  end
end

return
{
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({})

    vim.keymap.set("n", "<leader>hf", list_from_folder, { desc = 'Create [H]arpoon list from current [F]older.' })
    vim.keymap.set("n", "<leader>hd", list_remove, { desc = '[H]arpoon [D]elete current folder list' })
    -- vim.keymap.set("n", "<leader>hx", remove_file_from_list, { desc = 'Harpoon this file from current list' })
    vim.keymap.set("n", "<C-l>", next_list, {desc = 'next list'})
    vim.keymap.set("n", "<C-e>", show_folder_list, {desc = 'Show the current directory harpoon list'})
    vim.keymap.set("n", "<Tab>", cycle_folder_list_next, { desc = 'next element on list'})
    vim.keymap.set("n", "<S-Tab>", cycle_folder_list_prev, {desc = 'prev element on list'})
  end
}
