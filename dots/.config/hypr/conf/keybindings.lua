local G = require("conf.globals")
local monitors = require("conf.util.monitors")
local windows = require("conf.util.windows")

hl.bind(G.main_mod .. " + C", hl.dsp.window.close())
hl.bind(G.main_mod .. " + SPACE", hl.dsp.exec_cmd("rofi -show drun"))

hl.bind(G.main_mod .. " + RETURN", hl.dsp.exec_cmd(G.terminal))
hl.bind(G.main_mod .. " + B", hl.dsp.exec_cmd(G.browser))
hl.bind(G.main_mod .. " + E", hl.dsp.exec_cmd(G.file_manager))

hl.bind(G.main_mod .. " + SHIFT + Q", hl.dsp.exec_cmd(G.logout))
hl.bind(G.main_mod .. " + Q", hl.dsp.exec_cmd(G.lock_screen))

hl.bind(G.main_mod .. " + SHIFT + W", hl.dsp.exec_cmd("wallpaper.sh"))
hl.bind(
	G.main_mod .. " + Z",
	hl.dsp.exec_cmd("wpchanger.sh ~/Pictures/Wallpapers/windows-7-official-3840x2160-13944.jpg")
)

hl.bind(G.main_mod .. " + S", hl.dsp.exec_cmd("screenshot.sh --instant"))
hl.bind(G.main_mod .. " + SHIFT + S", hl.dsp.exec_cmd("quickshell -c HyprQuickFrame -n"))

hl.bind(G.main_mod .. " + W", hl.dsp.exec_cmd("toggle-waybar.sh"))
hl.bind(G.main_mod .. " + D", function()
	monitors.toggle("eDP-1")
end)

hl.bind(G.main_mod .. " + P", hl.dsp.window.pseudo())
hl.bind(G.main_mod .. " + T", hl.dsp.layout("togglesplit"))
hl.bind(G.main_mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(G.main_mod .. " + N", hl.dsp.window.float({ action = "toggle" }))
hl.bind(G.main_mod .. " + M", hl.dsp.layout("movetoroot"))

hl.bind(G.main_mod .. " + TAB", hl.dsp.focus({ monitor = "+1" }))
hl.bind(G.main_mod .. " + SHIFT + TAB", hl.dsp.workspace.move({ monitor = "+1" }))

hl.bind(G.main_mod .. " + equal", function() monitors.scale_up() end)
hl.bind(G.main_mod .. " + minus", function() monitors.scale_down() end)

local dirs = { H = "l", L = "r", K = "u", J = "d" }

for key, dir in pairs(dirs) do
	hl.bind(G.main_mod .. " + " .. key, hl.dsp.focus({ direction = dir }))
	hl.bind(G.main_mod .. " + SHIFT + " .. key, hl.dsp.window.swap({ direction = dir }))
end

for i = 1, 10 do
	local key = i % 10
	hl.bind(G.main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(G.main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
	hl.bind(G.main_mod .. " + CTRL + " .. key, function()
		windows.move_all_to(i)
	end)
end

hl.bind(G.main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(G.main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(G.main_mod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
	hl.bind("SHIFT + L", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + H", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + K", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
	hl.bind("SHIFT + J", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })

	hl.bind("L", hl.dsp.window.move({ x = 40, y = 0, relative = true }), { repeating = true })
	hl.bind("H", hl.dsp.window.move({ x = -40, y = 0, relative = true }), { repeating = true })
	hl.bind("K", hl.dsp.window.move({ x = 0, y = -40, relative = true }), { repeating = true })
	hl.bind("J", hl.dsp.window.move({ x = 0, y = 40, relative = true }), { repeating = true })

	hl.bind("C", hl.dsp.window.center())
	hl.bind("escape", hl.dsp.submap("reset"))
end)

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("volume.sh --inc"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("volume.sh --dec"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("volume.sh --toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("volume.sh --toggle-mic"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightness.sh increase 5"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightness.sh decrease 5"), { locked = true, repeating = true })

hl.bind(
	"XF86Display",
	hl.dsp.exec_cmd(
		'if [ "$(brightnessctl -d *::kbd_backlight get)" -eq 0 ]; then brightnessctl -d *::kbd_backlight set 100%; else brightnessctl -d *::kbd_backlight set 0%; fi'
	)
)

hl.bind(
	"XF86WLAN",
	hl.dsp.exec_cmd("if nmcli networking | grep -q enabled; then nmcli networking off; else nmcli networking on; fi")
)

hl.bind("XF86NotificationCenter", hl.dsp.exec_cmd("swaync-client -t -sw"))

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("switch:on:Lid Switch", function()
	monitors.enable("eDP-1")
end, { locked = true })
hl.bind("switch:off:Lid Switch", function()
	monitors.disable("eDP-1")
end, { locked = true })
