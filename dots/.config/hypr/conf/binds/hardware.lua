local monitors = require("conf.util.monitors")

return {
	{ "XF86MonBrightnessUp", hl.dsp.exec_cmd("brightness.sh increase 5"), { locked = true, repeating = true } },
	{ "XF86MonBrightnessDown", hl.dsp.exec_cmd("brightness.sh decrease 5"), { locked = true, repeating = true } },
	{
		"XF86Display",
		hl.dsp.exec_cmd(
			'if [ "$(brightnessctl -d *::kbd_backlight get)" -eq 0 ]; then brightnessctl -d *::kbd_backlight set 100%; else brightnessctl -d *::kbd_backlight set 0%; fi'
		),
	},
	{
		"XF86WLAN",
		hl.dsp.exec_cmd(
			"if nmcli networking | grep -q enabled; then nmcli networking off; else nmcli networking on; fi"
		),
	},
	{
		"switch:on:Lid Switch",
		function()
			monitors.enable("eDP-1")
		end,
		{ locked = true },
	},
	{
		"switch:off:Lid Switch",
		function()
			monitors.disable("eDP-1")
		end,
		{ locked = true },
	},
}
