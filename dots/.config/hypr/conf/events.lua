local G = require("conf.globals")
local monitors = require("conf.util.monitors")

local execs = {
	"waybar",
	"awww-daemon & sleep 0.1 && awww img -t none " .. G.cache .. "/wallpaper/current",
	"hypridle",
	"systemctl --user start hyprpolkitagent",
	"wl-paste --type text --watch cliphist store",
	"wl-paste --type image --watch cliphist store",
	"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
	"waybar_auto_hide",
	"hyprsunset",
	"gnome-keyring-daemon --start --components=secrets",
}

local function redetect_brightness()
	hl.dispatch(hl.dsp.exec_cmd("brightness.sh redetect"))
end

local function handle_bitwarden(window)
	if window.title ~= nil and window.title:find("%(Bitwarden Password Manager%) %- Bitwarden") then
		local monitor = monitors.get_active()
		local width = math.floor(monitor.width * 0.15)
		local height = math.floor(monitor.height * 0.35)
		hl.dispatch(hl.dsp.window.float({ action = "toggle", window = window }))
		hl.dispatch(hl.dsp.window.resize({ window = window, x = width, y = height }))
		hl.dispatch(hl.dsp.window.center({ window = window }))
	end
end

local function autostart()
	for _, exec in ipairs(execs) do
		hl.exec_cmd(exec)
	end
end

local function register_events(events)
	for _, e in ipairs(events) do
		hl.on(e[1], e[2])
	end
end

register_events({
	{ "hyprland.start", autostart },
	{ "monitor.added", redetect_brightness },
	{ "monitor.removed", redetect_brightness },
	{ "window.title", handle_bitwarden },
})
