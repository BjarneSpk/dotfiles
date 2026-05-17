local main_mod = require("conf.globals").main_mod

local function make_notification_handle()
	local handle = nil
	return {
		show = function(text, icon)
			if handle ~= nil and handle:is_alive() then
				return
			end
			handle = hl.notification.create({
				text = text,
				duration = 3600 * 24 * 1000,
				icon = icon or 1,
			})
		end,
		hide = function()
			if handle == nil then
				return
			end
			handle:dismiss()
			handle = nil
		end,
	}
end

local function with_notification(submap)
	if not submap.notification_text then
		return submap
	end

	local n = make_notification_handle()

	local original_enter = submap.on_enter
	submap.on_enter = function()
		n.show(submap.notification_text, submap.notification_icon)
		if original_enter then
			original_enter()
		end
	end

	local original_exit = submap.on_exit
	submap.on_exit = function()
		n.hide()
		if original_exit then
			original_exit()
		end
	end

	for _, bind in ipairs(submap.binds) do
		if bind[1]:lower() == "escape" then
			local original_action = bind[2]
			bind[2] = function()
				submap.on_exit()
				if original_action then
					original_action()
				end
			end
		end
	end

	submap.notification_text = nil
	submap.notification_icon = nil
	return submap
end

return {
	with_notification({
		trigger = main_mod .. " + R",
		name = "resize",
		notification_text = " Resize\n VIM move/resize · (C)enter · Esc",
		notification_icon = 1,
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
			{
				"escape",
				function()
					hl.dispatch(hl.dsp.submap("reset"))
				end,
			},
		},
	}),
}
