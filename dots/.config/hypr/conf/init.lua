local function register_env(vars)
    for _, e in ipairs(vars) do
        hl.env(e[1], e[2])
    end
end

register_env(require("conf.env"))

require("conf.autostart")
require("conf.general")
require("conf.look")
require("conf.rules.init")
require("conf.binds.init")
require("conf.input")
require("conf.events")
