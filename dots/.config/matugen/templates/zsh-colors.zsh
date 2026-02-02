export PROMPT=' %F{{"{"}}{{colors.primary.default.hex}}{{"}"}}%n%f %F{{"{"}}{{colors.source_color.default.hex}}{{"}"}}%1~%f %F{{"{"}}{{colors.on_surface.default.hex}}{{"}"}}%#%f '
export FZF_DEFAULT_OPTS="
    --style=full
    --color=fg:{{colors.on_surface.default.hex}},hl:{{colors.primary.default.hex}}
    --color=fg+:{{colors.on_surface_variant.default.hex}},hl+:{{colors.primary_container.default.hex}}
    --color=border:{{colors.outline.default.hex}},header:{{colors.secondary.default.hex}},gutter:{{colors.surface_dim.default.hex}}
    --color=spinner:{{colors.tertiary.default.hex}},info:{{colors.secondary_container.default.hex}}
    --color=pointer:{{colors.primary_fixed.default.hex}},marker:{{colors.error.default.hex}},prompt:{{colors.on_background.default.hex}}"
