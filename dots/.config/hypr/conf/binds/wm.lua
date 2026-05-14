local G = require("conf.globals")
local monitors = require("conf.util.monitors")
local windows = require("conf.util.windows")

local binds = {
	{ G.main_mod .. " + P", hl.dsp.window.pseudo() },
	{ G.main_mod .. " + T", hl.dsp.layout("togglesplit") },
	{ G.main_mod .. " + F", hl.dsp.window.fullscreen() },
	{ G.main_mod .. " + N", hl.dsp.window.float({ action = "toggle" }) },
	{ G.main_mod .. " + M", hl.dsp.layout("movetoroot") },
	{ G.main_mod .. " + TAB", hl.dsp.focus({ monitor = "+1" }) },
	{ G.main_mod .. " + SHIFT + TAB", hl.dsp.workspace.move({ monitor = "+1" }) },
	{ G.main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true } },
	{ G.main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true } },
}

local dirs = { H = "l", L = "r", K = "u", J = "d" }
for key, dir in pairs(dirs) do
	table.insert(binds, { G.main_mod .. " + " .. key, hl.dsp.focus({ direction = dir }) })
	table.insert(binds, { G.main_mod .. " + SHIFT + " .. key, hl.dsp.window.swap({ direction = dir }) })
end

for i = 1, 10 do
	local key = i % 10
	table.insert(binds, { G.main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }) })
	table.insert(binds, { G.main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }) })
	table.insert(binds, {
		G.main_mod .. " + CTRL + " .. key,
		function()
			windows.move_all_to(i)
		end,
	})
end

table.insert(binds, {
	G.main_mod .. " + equal",
	function()
		monitors.scale_up()
	end,
})
table.insert(binds, {
	G.main_mod .. " + minus",
	function()
		monitors.scale_down()
	end,
})

table.insert(binds, {
	G.main_mod .. " + D",
	function()
		monitors.toggle("eDP-1")
	end,
})

return binds
