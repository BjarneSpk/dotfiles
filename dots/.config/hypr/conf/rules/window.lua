return {
	{
		match = { class = "org.gnome.Nautilus" },
		opacity = "0.85 override 0.85 override 0.85 override",
	},
	{
		name = "suppress-maximize-events",
		match = { class = ".*" },
		suppress_event = "maximize",
	},
	{
		name = "fix-xwayland-drags",
		match = {
			class = "^$",
			title = "^$",
			xwayland = true,
			float = true,
			fullscreen = false,
			pin = false,
		},
		no_focus = true,
	},
	{
		name = "wppicker",
		match = { title = "wallpaper-picker" },
		float = true,
		size = { "monitor_w", "monitor_h * 0.46" },
		border_size = 0,
		no_blur = true,
		no_shadow = true,
	},
	{
		name = "popup-floating",
		match = { class = "dotfiles-floating|org.pulseaudio.pavucontrol|blueman-manager" },
		size = { "monitor_w * 0.5", "monitor_h * 0.5" },
		float = true,
		center = true,
	},
}
