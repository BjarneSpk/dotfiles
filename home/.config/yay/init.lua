yay.opt.build_dir = os.getenv("HOME") .. "/.cache/yay" -- Build/cache directory for AUR packages.
yay.opt.editor = os.getenv("EDITOR") or os.getenv("VISUAL") or "vi" -- Editor command used for PKGBUILD edits; empty uses VISUAL/EDITOR.

dofile(os.getenv("HOME") .. "/.config/yay/hooks/hide_first_submitted.lua")
dofile(os.getenv("HOME") .. "/.config/yay/hooks/install_log.lua")
dofile(os.getenv("HOME") .. "/.config/yay/hooks/maintainer_change.lua")
dofile(os.getenv("HOME") .. "/.config/yay/hooks/recently_modified.lua")
