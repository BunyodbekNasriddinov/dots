-- Function to search based on visual selection
local function search_visual_selection()
	-- Get the selected text in Visual mode
	local mode = vim.fn.visualmode()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local lines = vim.fn.getline(start_pos[2], end_pos[2])
	local selected_text = table.concat(lines, "\n"):sub(start_pos[3], end_pos[3])

	-- Check if the selected text is not empty
	if selected_text ~= "" then
		-- Call Telescope with the selected text
		require("telescope.builtin").grep_string({
			search = selected_text,
			additional_args = function(opts)
				return { "--glob=!node_modules/*", "--glob=!dist/*", "--glob=!build/*" }
			end,
		})
	else
		print("No text selected")
	end
end

-- Keymap to trigger the function in Visual mode
vim.api.nvim_set_keymap("x", "<C-e>", ":lua search_visual_selection()<CR>", { noremap = true, silent = true })
