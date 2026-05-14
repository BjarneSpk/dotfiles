local monitor = require("conf.util.monitors")

hl.config({
	general = {
		resize_on_border = true,
		no_focus_fallback = true,
		allow_tearing = true,
		layout = "dwindle",
	},
	dwindle = {
		preserve_split = true,
	},
	master = {
		new_status = "master",
	},
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		disable_autoreload = true,
		vrr = 1,
	},
	cursor = {
		no_hardware_cursors = true,
	},
	debug = {
		disable_logs = true,
	},
	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},
})

hl.permission({ binary = "/usr/(bin|local/bin)/grim", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/(bin|local/bin)/hyprlock", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })

if monitor.lid_is_closed() then
	monitor.disable("eDP-1")
else
	hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1 })
end

hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto", scale = 1 })
hl.monitor({ output = "HDMI-A-2", mode = "preferred", position = "auto", scale = 1.6 })
hl.monitor({ output = "DP-1", mode = "preferred", position = "auto", scale = 1.5 })
hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1.5 })
