local function register(binds)
    for _, b in ipairs(binds) do
        hl.bind(b[1], b[2], b[3])
    end
end

local function enter_submap(submap)
    return function()
        if submap.on_enter ~= nil then
            submap.on_enter()
        end
        hl.dispatch(hl.dsp.submap(submap.name))
    end
end

local function register_submaps(defs)
    for _, submap in ipairs(defs) do
        hl.bind(submap.trigger, enter_submap(submap))
        hl.define_submap(submap.name, function()
            register(submap.binds)
        end)
    end
end

register(require("conf.binds.apps"))
register(require("conf.binds.media"))
register(require("conf.binds.hardware"))
register(require("conf.binds.wm"))
register_submaps(require("conf.binds.submaps"))
