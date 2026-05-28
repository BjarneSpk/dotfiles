local workspaces = require("conf.util.workspaces")

local M = {}

local DEFAULT_OPTS = {
	float = {
		scale = 0.8,
		center = true,
	},
	pseudo = {
		scale = 0.8,
	},
}

local pseudo_state = {}

local function window_ids(windows)
	local ids = {}
	for _, w in ipairs(windows) do
		ids[w.address] = true
	end
	return ids
end

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
			hl.dispatch(hl.dsp.window.float({ action = "off", window = w }))
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
		hl.dispatch(hl.dsp.window.float({ action = "on", window = snap.w }))
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

		hl.dispatch(hl.dsp.window.resize({ action = "on", window = snap.w, x = new_w, y = new_h }))
		hl.dispatch(hl.dsp.window.move({ window = snap.w, x = new_x, y = new_y }))
	end
end

function M.toggle_all_pseudo(user_opts)
	local opts = user_opts ~= nil and user_opts or DEFAULT_OPTS

	local workspace = workspaces.get_active()
	local tiled = hl.get_windows({ floating = false, workspace = workspace.id })
	if #tiled == 0 then
		pseudo_state[workspace.id] = nil
		return
	end

	local current_ids = window_ids(tiled)
	local state = pseudo_state[workspace.id]
	if state and state.enabled then
		local has_known = false
		for addr in pairs(state.ids or {}) do
			if current_ids[addr] then
				has_known = true
				break
			end
		end
		if not has_known then
			state = nil
		end
	end

	local enable = not (state and state.enabled)
	local action = enable and "on" or "off"
	local snapshots = {}
	if enable then
		for _, w in ipairs(tiled) do
			snapshots[#snapshots + 1] = {
				w = w,
				width = w.size.x,
				height = w.size.y,
			}
		end
	end

	for _, w in ipairs(tiled) do
		hl.dispatch(hl.dsp.window.pseudo({ action = action, window = w }))
	end

	if enable and #snapshots > 0 then
		local scale = (opts.pseudo and opts.pseudo.scale) or DEFAULT_OPTS.pseudo.scale
		for _, snap in ipairs(snapshots) do
			local new_w = math.floor(snap.width * scale)
			local new_h = math.floor(snap.height * scale)
			hl.dispatch(hl.dsp.window.resize({ action = "exact", window = snap.w, x = new_w, y = new_h }))
		end
	end

	pseudo_state[workspace.id] = { enabled = enable, ids = current_ids }
end

return M
