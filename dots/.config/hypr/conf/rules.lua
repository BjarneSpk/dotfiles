hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

hl.layer_rule({
    match = { namespace = "swaync-control-center" },
    blur = true,
})

hl.layer_rule({
    match = { namespace = "swaync-notification-window" },
    ignore_alpha = 0.21,
})

hl.layer_rule({
    match = { namespace = "swaync-control-center" },
    animation = "slide right",
})

hl.layer_rule({
    match = { namespace = "swaync-control-center" },
    ignore_alpha = 0.21,
})

hl.layer_rule({
    match = { namespace = "rofi" },
    no_anim = true,
})

hl.workspace_rule({
    workspace = "m[DP-2]",
    gaps_in = 6,
    gaps_out = 8,
    border_size = 2,
})

hl.window_rule({
    name = "wppicker",
    match = { title = "wallpaper-picker" },
    float = true,
    size = { "monitor_w", "(monitor_h*0.46)" },
    border_size = 0,
    no_blur = true,
    no_shadow = true,
})

hl.window_rule({
    name = "popup-floating",
    match = { class = "dotfiles-floating|org.pulseaudio.pavucontrol|blueman-manager" },
    size = { "(monitor_w*0.5)", "(monitor_h*0.5)" },
    float = true,
    center = true,
})
