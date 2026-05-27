local workspaces = require("conf.util.workspaces")

local M = {}

local DEFAULT_OPTS = {
	float = {
		scale = 0.8,
		center = true,
	},
}

function M.get_active()
	return assert(hl.get_active_window(), "no active window")
end

function M.move_all_to(target_workspace)
	local workspace = workspaces.get_active()
	local windows = hl.get_workspace_windows(workspace)

	for _, w in ipairs(windows) do
		hl.dispatch(hl.dsp.window.move({ workspace = target_workspace, window = w }))
	end
end

function M.toggle_all_float(user_opts)
	local opts = user_opts ~= nil and user_opts or DEFAULT_OPTS

	local workspace = workspaces.get_active()
  local floating = hl.get_windows({ floating = true, workspace = workspace.id })
  local tiled = hl.get_windows({ floating = false, workspace = workspace.id })

	if #floating > 0 then
		for _, w in ipairs(floating) do
			hl.dispatch(hl.dsp.window.float({ action = "unset", window = w }))
		end
		return
	end

	local snapshots = {}
	for _, w in ipairs(tiled) do
		snapshots[#snapshots + 1] = {
			w = w,
			x = w.at.x,
			y = w.at.y,
			width = w.size.x,
			height = w.size.y,
		}
	end

	for _, snap in ipairs(snapshots) do
		hl.dispatch(hl.dsp.window.float({ action = "set", window = snap.w }))
	end

	for _, snap in ipairs(snapshots) do
		local new_w = math.floor(snap.width * opts.float.scale)
		local new_h = math.floor(snap.height * opts.float.scale)
		local new_x, new_y

		if opts.float.center then
			new_x = math.floor(snap.x + (snap.width - new_w) / 2)
			new_y = math.floor(snap.y + (snap.height - new_h) / 2)
		else
			new_x = snap.x
			new_y = snap.y
		end

		hl.dispatch(hl.dsp.window.resize({ action = "exact", window = snap.w, x = new_w, y = new_h }))
		hl.dispatch(hl.dsp.window.move({ window = snap.w, x = new_x, y = new_y }))
	end
end

return M
