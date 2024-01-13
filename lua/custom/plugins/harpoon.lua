local function from_folder()
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

return
{
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    vim.keymap.set("n", "<leader>hfl", from_folder)
    vim.keymap.set("n", "<C-e>", show_folder_list)
    vim.keymap.set("n", "<Tab>", cycle_folder_list_next)
    vim.keymap.set("n", "<S-Tab>", cycle_folder_list_prev)
    -- vim.keymap.set("n", "<leader>z", folderToHarpoon2)
    -- vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list('magia')) end)
    -- vim.keymap.set("n", "<C-l>", function() harpoon:list('magia'):prev({ ui_nav_wrap = true }) end)
    -- vim.keymap.set("n", "<C-y>", function() harpoon:list('magia'):next({ ui_nav_wrap = true }) end)
  end
}
