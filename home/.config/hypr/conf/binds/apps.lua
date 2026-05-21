local G = require("conf.globals")
local main_mod = G.main_mod

return {
	{ main_mod .. " + C", hl.dsp.window.close() },
	{ main_mod .. " + SPACE", hl.dsp.exec_cmd("rofi -show drun") },
	{ main_mod .. " + RETURN", hl.dsp.exec_cmd(G.terminal) },
	{ main_mod .. " + B", hl.dsp.exec_cmd(G.browser) },
	{ main_mod .. " + E", hl.dsp.exec_cmd(G.file_manager) },
	{ main_mod .. " + SHIFT + Q", hl.dsp.exec_cmd(G.logout) },
	{ main_mod .. " + Q", hl.dsp.exec_cmd(G.lock_screen) },
	{ main_mod .. " + W", hl.dsp.exec_cmd("toggle-waybar.sh") },
	{ main_mod .. " + SHIFT + W", hl.dsp.exec_cmd("wallpaper.sh") },
	{
		main_mod .. " + Z",
		hl.dsp.exec_cmd("wpchanger.sh ~/Pictures/Wallpapers/windows-7-official-3840x2160-13944.jpg"),
	},
	{ main_mod .. " + S", hl.dsp.exec_cmd("screenshot.sh --instant") },
	{ main_mod .. " + SHIFT + S", hl.dsp.exec_cmd("quickshell -c HyprQuickFrame -n") },
	{ "XF86NotificationCenter", hl.dsp.exec_cmd("swaync-client -t -sw") },
}
