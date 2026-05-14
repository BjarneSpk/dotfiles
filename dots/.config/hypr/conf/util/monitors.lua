local M = {}

function M.get_active()
	return assert(hl.get_active_monitor(), "no active monitor")
end

function M.is_on(target_monitor)
	for _, monitor in ipairs(hl.get_monitors()) do
		if monitor.name == target_monitor then
			return true
		end
	end
	return false
end

function M.disable(monitor)
	hl.monitor({ output = monitor, disabled = true })
end

function M.enable(monitor, mode, position, scale)
	mode = mode or "preferred"
	position = position or "auto"
	scale = scale or 1
	hl.monitor({ output = monitor, mode = mode, position = position, scale = scale })
end

function M.toggle(monitor)
	if M.is_on(monitor) then
		M.disable(monitor)
	else
		M.enable(monitor)
	end
end

function M.lid_is_closed()
	local handle = assert(io.popen("cat /proc/acpi/button/lid/*/state 2>/dev/null"), "couldn't read Lid Switch file")
	local result = handle:read("*a")
	handle:close()
	return result:find("closed") ~= nil
end

local function is_valid_scale(width, height, scale)
	local function is_int(n)
		return math.abs(n - math.floor(n)) < 0.001
	end
	return is_int(width / scale) and is_int(height / scale)
end

local function find_next_valid(current, step)
	local monitor = M.get_active()
	for i = 1, 200 do
		local candidate = math.floor((current + step * i) * 100 + 0.5) / 100
		if is_valid_scale(monitor.width, monitor.height, candidate) then
			return candidate
		end
	end
	return nil
end

local function apply_scale(step)
	local monitor = M.get_active()
	local new_scale = find_next_valid(monitor, step)
	if not new_scale then
		return
	end
	hl.monitor({ output = monitor.name, mode = "preferred", position = "auto", scale = new_scale })
end

function M.scale_up()
	apply_scale(0.01)
end

function M.scale_down()
	apply_scale(-0.01)
end

return M
