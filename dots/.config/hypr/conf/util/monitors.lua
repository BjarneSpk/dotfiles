local M = {}

function M.is_on(monitor)
	-- for _, m in ipairs(hl.get_monitors()) do
	-- 	if m.name == monitor then
	-- 		return true
	-- 	end
	-- end
	-- return false
	local status = os.execute(
		string.format(
			"hyprctl monitors all -j | jq -e --arg m '%s' 'first(.[] | select((.name // \"\") == $m)) | ((.disabled // false) | not)'",
			monitor
		)
	)
	return status == 0
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

return M
