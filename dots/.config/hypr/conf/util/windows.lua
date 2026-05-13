local M = {}

function M.move_all_to(target_workspace)
	local workspace = assert(hl.get_active_workspace(), "no active workspace")
  local windows = hl.get_workspace_windows(workspace)

	for _, w in ipairs(windows) do
    hl.dispatch(hl.dsp.window.move({ workspace = target_workspace, window = w }))
	end

	hl.dispatch(hl.dsp.focus({ workspace = target_workspace }))
end

return M
