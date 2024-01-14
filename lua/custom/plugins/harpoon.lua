local function list_from_folder()
  local harpoon = require("harpoon")
  local plenary = require("plenary")

  local currentFile = vim.fn.expand('%')
  local dir = vim.fn.expand('%:p:h')
  local relativeDir = plenary.path:new(dir):make_relative()

  local files = vim.fn.systemlist("ls -p " .. dir .. " | grep -v /")
  for k in pairs(files) do
    local path = relativeDir .. "/" .. files[k]
    harpoon:list(relativeDir):append({ context = { col = 0, row = 1 }, value = path })
  end
end


local function cycle_folder_list_next()
  local harpoon = require("harpoon")
  local dir = vim.fn.expand('%:p:h')
  local plenary = require("plenary")
  local relativeDir = plenary.path:new(dir):make_relative()
  print("next in Harpoon List: ", relativeDir)
  harpoon:list(relativeDir):next({ ui_nav_wrap = true })
end

local function cycle_folder_list_prev()
  local harpoon = require("harpoon")
  local dir = vim.fn.expand('%:p:h')
  local plenary = require("plenary")
  local relativeDir = plenary.path:new(dir):make_relative()
  print("prev in Harpoon List: ", relativeDir)
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
  local next_key = getNextKeyValuePair(relativeDir, harpoon.lists[harpoonKey])
  harpoon:list(next_key):select(harpoon:list(next_key)._index)
  print("Harpoon list: " .. next_key)
end

return
{
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    -- package.path = package.path .. ";../../keymaps.lua"
    -- keymaps = require("keymaps")
    -- harpoonKeyMaps()

    vim.keymap.set("n", "<leader>hl", "<Nop>", { desc = 'Create Harpoon list from current folder.' })
    vim.keymap.set("n", "<leader>hlf", list_from_folder, { desc = 'Create Harpoon list from current folder.' })
    vim.keymap.set("n", "<C-e>", show_folder_list)
    vim.keymap.set("n", "<Tab>", cycle_folder_list_next)
    vim.keymap.set("n", "<S-Tab>", cycle_folder_list_prev)
    vim.keymap.set("n", "<leader>hlr", list_remove, { desc = 'Remove Harpoon list' })
    vim.keymap.set("n", "<C-l>", next_list)

    -- vim.keymap.set("n", "<leader>z", folderToHarpoon2)
    -- vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list('magia')) end)
    -- vim.keymap.set("n", "<C-l>", function() harpoon:list('magia'):prev({ ui_nav_wrap = true }) end)
    -- vim.keymap.set("n", "<C-y>", function() harpoon:list('magia'):next({ ui_nav_wrap = true }) end)
  end
}
