return {
	{ "XF86AudioRaiseVolume", hl.dsp.exec_cmd("volume.sh --inc"), { locked = true, repeating = true } },
	{ "XF86AudioLowerVolume", hl.dsp.exec_cmd("volume.sh --dec"), { locked = true, repeating = true } },
	{ "XF86AudioMute", hl.dsp.exec_cmd("volume.sh --toggle"), { locked = true, repeating = true } },
	{ "XF86AudioMicMute", hl.dsp.exec_cmd("volume.sh --toggle-mic"), { locked = true, repeating = true } },
	{ "XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true } },
	{ "XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true } },
	{ "XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true } },
	{ "XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true } },
}
