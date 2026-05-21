local G = require("conf.globals")

local function register_env(vars)
	for _, e in ipairs(vars) do
		hl.env(e[1], e[2])
	end
end

register_env({
	{ "QT_QPA_PLATFORMTHEME", "qt6ct" },
	{ "QT_AUTO_SCREEN_SCALE_FACTOR", "1" },
	{ "QT_WAYLAND_DISABLE_WINDOWDECORATION", "1" },
	{ "VDPAU_DRIVER", "va_gl" },
	{ "ANV_DEBUG", "video-decode,video-encode" },
	{ "GDK_BACKEND", "wayland,x11,*" },
	{ "QT_QPA_PLATFORM", "wayland;xcb" },
	{ "SDL_VIDEODRIVER", "wayland" },
	{ "CLUTTER_BACKEND", "wayland" },
	{ "XDG_CURRENT_DESKTOP", "Hyprland" },
	{ "XDG_SESSION_TYPE", "wayland" },
	{ "XDG_SESSION_DESKTOP", "Hyprland" },
	{ "ELECTRON_OZONE_PLATFORM", "wayland" },
	{ "ELECTRON_OZONE_PLATFORM_HINT", "auto" },
	{ "DOCKER_HOST", "unix:///run/user/1000/podman/podman.sock" },
	{ "SCRIPTS", G.scripts },
	{ "CACHE", G.cache },
})
