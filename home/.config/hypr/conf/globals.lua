local wlogout = require("conf.util.wlogout")

return {
	scripts = os.getenv("HOME") .. "/dotfiles/scripts/",
	cache = os.getenv("HOME") .. "/.cache/arch-rice",

	terminal = "kitty",
	browser = "firefox",
	file_manager = "nautilus",
	lock_screen = "hyprlock",
	logout = wlogout.launch,
  waybar_theme = "glass",

	main_mod = "SUPER",
}
