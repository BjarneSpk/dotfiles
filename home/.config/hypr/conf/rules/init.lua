local window_rules = require("conf.rules.window")
local layer_rules = require("conf.rules.layer")
local workspace_rules = require("conf.rules.workspace")

for _, window_rule in ipairs(window_rules) do
	hl.window_rule(window_rule)
end

for _, layer_rule in ipairs(layer_rules) do
	hl.layer_rule(layer_rule)
end

for _, workspace_rule in ipairs(workspace_rules) do
	hl.workspace_rule(workspace_rule)
end
