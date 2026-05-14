local G = require("conf.globals")

local execs = {
	"waybar",
	"awww-daemon & sleep 0.1 && awww img -t none " .. G.cache .. "/wallpaper/current",
	"hypridle",
	"systemctl --user start hyprpolkitagent",
	"wl-paste --type text --watch cliphist store",
	"wl-paste --type image --watch cliphist store",
	"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
	"waybar_auto_hide",
	"hyprsunset",
	"gnome-keyring-daemon --start --components=secrets",
}

hl.on("hyprland.start", function()
  for _, exec in ipairs(execs) do
    hl.exec_cmd(exec)
  end
end)
