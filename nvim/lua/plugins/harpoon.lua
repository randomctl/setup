local harpoon = require("harpoon")
harpoon:setup({
	settings = {
		save_on_toggle = true,
	},
})
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<C-e>"] = actions.close,
			},
			n = {
				["<C-e>"] = actions.close,
			},
		},
	},
})

local conf = require("telescope.config").values

local function toggle_telescope(harpoon_files)
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = require("telescope.finders").new_table({
				results = file_paths,
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				local function delete_selected()
					local selection = action_state.get_selected_entry()

					table.remove(harpoon_files.items, selection.index)

					actions.close(prompt_bufnr)

					vim.schedule(function()
						toggle_telescope(harpoon_files)
					end)
				end

				-- insert mode
				map("i", "<C-d>", delete_selected)

				-- normal mode
				map("n", "dd", delete_selected)

				return true
			end,
		})
		:find()
end

vim.keymap.set("n", "<C-e>", function()
	toggle_telescope(harpoon:list())
end, { desc = "Open harpoon window" })

vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end)

--vim.keymap.set("n", "<C-e>", function()
--	harpoon.ui:toggle_quick_menu(harpoon:list())
--end)

vim.keymap.set("n", "<C-h>", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "<C-t>", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "<C-n>", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "<C-s>", function()
	harpoon:list():select(4)
end)
