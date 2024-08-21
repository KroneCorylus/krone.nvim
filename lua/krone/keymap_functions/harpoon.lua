local harpoon = require("harpoon")
local plenary = require("plenary")
function list_from_folder()
	local currentFile = vim.fn.expand('%')
	local relativeDir = plenary.path:new(vim.fn.expand('%:p:h')):make_relative()

	local files = vim.fn.systemlist("ls -p " .. dir .. " | grep -v /")
	for k in pairs(files) do
		local path = relativeDir .. "/" .. files[k]
		harpoon:list(relativeDir):append({ context = { col = 0, row = 1 }, value = path })
	end
end

function cycle_folder_list_next()
	local relativeDir = plenary.path:new(vim.fn.expand('%:p:h')):make_relative()
	print("next in Harpoon List: ", relativeDir)
	harpoon:list(relativeDir):next({ ui_nav_wrap = true })
end

function cycle_folder_list_prev()
	local relativeDir = plenary.path:new(vim.fn.expand('%:p:h')):make_relative()
	print("prev in Harpoon List: ", relativeDir)
	harpoon:list(relativeDir):prev({ ui_nav_wrap = true })
end

function show_folder_list()
	local dir = vim.fn.expand('%:p:h')
	local relativeDir = plenary.path:new(dir):make_relative()
	harpoon.ui:toggle_quick_menu(harpoon:list(relativeDir))
end

function list_remove()
	local relativeDir = plenary.path:new(vim.fn.expand('%:p:h')):make_relative()
	local harpoonKey = harpoon.config.settings.key()
	harpoon.lists[harpoonKey][relativeDir] = nil
	harpoon.data:update(harpoonKey, relativeDir, nil)
end

function getNextKeyValuePair(currentKey, myTable)
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

function next_list()
	local harpoonKey = harpoon.config.settings.key();
	local relativeDir = plenary.path:new(vim.fn.expand('%:p:h')):make_relative()
	local next_key = getNextKeyValuePair(relativeDir, harpoon.lists[harpoonKey])
	harpoon:list(next_key):select(harpoon:list(next_key)._index)
	print("Harpoon list: " .. next_key)
end
