local monitors = require("conf.util.monitors")

local function redetect_brightness()
	hl.dispatch(hl.dsp.exec_cmd("brightness.sh redetect"))
end

hl.on("monitor.added", redetect_brightness)
hl.on("monitor.removed", redetect_brightness)

hl.on("window.title", function(window)
	if window.title ~= nil and window.title:find("%(Bitwarden Password Manager%) %- Bitwarden") then
		local monitor = monitors.get_active()
		local width = math.floor(monitor.width * 0.20)
		local height = math.floor(monitor.height * 0.54)

		hl.dispatch(hl.dsp.window.float({ action = "toggle", window = window }))
		hl.dispatch(hl.dsp.window.resize({ window = window, x = width, y = height }))
		hl.dispatch(hl.dsp.window.center({ window = window }))
	end
end)
