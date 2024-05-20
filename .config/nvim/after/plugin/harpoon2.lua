local harpoon = require("harpoon")

harpoon:setup({
	cmd = {
		add = function(possible_value)
			return {
				value = "Hello World",
			}
		end,

		select = function(list_item, list, option)
			vim.print(list_item.value)
		end,
	},
})

vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end)

vim.keymap.set("n", "<C-e>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<C-g>j", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "<C-g>k", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "<C-g>l", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "<C-g>;", function()
	harpoon:list():select(4)
end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function()
	harpoon:list():prev()
end)
vim.keymap.set("n", "<C-S-N>", function()
	harpoon:list():next()
end)
