local G = require("conf.globals")

return {
	{
		trigger = G.main_mod .. " + R",
		name = "resize",
		binds = {
			{ "SHIFT + L", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true } },
			{ "SHIFT + H", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true } },
			{ "SHIFT + K", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true } },
			{ "SHIFT + J", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true } },
			{ "L", hl.dsp.window.move({ x = 40, y = 0, relative = true }), { repeating = true } },
			{ "H", hl.dsp.window.move({ x = -40, y = 0, relative = true }), { repeating = true } },
			{ "K", hl.dsp.window.move({ x = 0, y = -40, relative = true }), { repeating = true } },
			{ "J", hl.dsp.window.move({ x = 0, y = 40, relative = true }), { repeating = true } },
			{ "C", hl.dsp.window.center() },
			{ "escape", hl.dsp.submap("reset") },
		},
	},
}
