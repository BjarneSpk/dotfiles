local main_mod = require("conf.globals").main_mod
local monitors = require("conf.util.monitors")
local windows = require("conf.util.windows")

local binds = {
	{ main_mod .. " + P", hl.dsp.window.pseudo() },
	{ main_mod .. " + T", hl.dsp.layout("togglesplit") },
	{ main_mod .. " + F", hl.dsp.window.fullscreen() },
	{ main_mod .. " + N", hl.dsp.window.float({ action = "toggle" }) },
	{ main_mod .. " + M", hl.dsp.layout("movetoroot") },
	{ main_mod .. " + TAB", hl.dsp.focus({ monitor = "+1" }) },
	{ main_mod .. " + SHIFT + TAB", hl.dsp.workspace.move({ monitor = "+1" }) },
	{ main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true } },
	{ main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true } },
	{
		main_mod .. " + equal",
		monitors.scale_up,
	},
	{
		main_mod .. " + minus",
		monitors.scale_down,
	},
	{
		main_mod .. " + D",
		function()
			monitors.toggle("eDP-1")
		end,
	},
}

local dirs = { H = "l", L = "r", K = "u", J = "d" }
for key, dir in pairs(dirs) do
	table.insert(binds, { main_mod .. " + " .. key, hl.dsp.focus({ direction = dir }) })
	table.insert(binds, { main_mod .. " + SHIFT + " .. key, hl.dsp.window.swap({ direction = dir }) })
end

for i = 1, 10 do
	local key = i % 10
	table.insert(binds, { main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }) })
	table.insert(binds, { main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }) })
	table.insert(binds, {
		main_mod .. " + CTRL + " .. key,
		function()
			windows.move_all_to(i)
			hl.dispatch(hl.dsp.focus({ workspace = i }))
		end,
	})
end
return binds
