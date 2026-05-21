local workspaces = require("conf.util.workspaces")

local M = {}

function M.move_all_to(target_workspace)
	local workspace = workspaces.get_active()
	local windows = hl.get_workspace_windows(workspace)

	for _, w in ipairs(windows) do
		hl.dispatch(hl.dsp.window.move({ workspace = target_workspace, window = w }))
	end
end

return M
