local M = {}

function M.is_on(monitor)
	for _, m in ipairs(hl.get_monitors()) do
		if m.name == monitor then
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

return M
