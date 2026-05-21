return {
	{
		match = { namespace = "swaync-control-center" },
		blur = true,
	},
	{
		match = { namespace = "swaync-notification-window" },
		ignore_alpha = 0.21,
	},
	{
		match = { namespace = "swaync-control-center" },
		animation = "slide right",
	},
	{
		match = { namespace = "swaync-control-center" },
		ignore_alpha = 0.21,
	},
	{
		match = { namespace = "rofi" },
		no_anim = true,
	},
}
