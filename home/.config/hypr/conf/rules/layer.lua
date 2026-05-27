return {
	{
		match = { namespace = "swaync-notification-window" },
		ignore_alpha = 0.21,
		blur = true,
	},
	{
		match = { namespace = "swaync-control-center" },
		animation = "slide right",
		ignore_alpha = 0.21,
		blur = true,
	},
	{
		match = { namespace = "rofi" },
		no_anim = true,
	},
}
