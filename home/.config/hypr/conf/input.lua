hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "altgr-intl",
		kb_model = "",
		kb_rules = "",
		follow_mouse = 1,
		numlock_by_default = true,
		repeat_delay = 200,
		sensitivity = 0,
		force_no_accel = false,
		touchpad = {
			natural_scroll = true,
			tap_to_click = true,
		},
		natural_scroll = true,
	},
	gestures = {
		workspace_swipe_touch = false,
	},
})

hl.device({
	name = "magic-mouse-von-bjarne",
	sensitivity = -0.6,
})

hl.device({
	name = "magic-keyboard-with-numeric-keypad",
})
