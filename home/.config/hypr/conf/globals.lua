return {
	scripts = os.getenv("HOME") .. "/dotfiles/scripts/",
	cache = os.getenv("HOME") .. "/.cache/arch-rice",

	terminal = "kitty",
	browser = "firefox",
	file_manager = "nautilus",
	lock_screen = "hyprlock",
	logout = "wlogout -b 6 -m 500",

	main_mod = "SUPER",
}
