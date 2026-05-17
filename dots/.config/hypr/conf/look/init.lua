local colors = require("conf.look.colors")
local curves = require("conf.look.curves")
local animations = require("conf.look.animations")

hl.config({
	general = {
		col = {
			active_border = { colors = { colors.primary, colors.on_primary }, angle = 90 },
			inactive_border = colors.on_primary,
		},
		gaps_in = 4,
		gaps_out = 5,
		border_size = 1,
	},
	decoration = {
		rounding = 15,
		dim_inactive = true,
		dim_strength = 0.025,
		dim_special = 0.07,
		shadow = {
			enabled = true,
			range = 30,
			offset = { 0, 2 },
			render_power = 4,
			color = "rgba(00000010)",
		},
		blur = {
			enabled = true,
			xray = true,
			special = false,
			new_optimizations = true,
			size = 8,
			passes = 1,
			brightness = 1.1,
			vibrancy = 0.2,
			vibrancy_darkness = 0.1,
			popups = false,
			popups_ignorealpha = 0.6,
			input_methods = true,
			input_methods_ignorealpha = 0.8,
		},
	},
	animations = {
		enabled = true,
	},
})

for _, c in ipairs(curves) do
	hl.curve(c[1], c[2])
end

for _, a in ipairs(animations) do
	hl.animation(a)
end
