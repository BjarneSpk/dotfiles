local monitors = require("conf.util.monitors")

local M = {}

function M.launch()
	local monitor = monitors.get_active()
	local margin = math.floor(monitor.width / 8)
	local cmd = string.format("wlogout -b 6 -m %d", margin)
	hl.exec_cmd(cmd)
end

return M
