# Shell theme template for matugen

export PROMPT=' %F{{"{"}}{{colors.primary.default.hex}}{{"}"}}%n%f %F{{"{"}}{{colors.tertiary.default.hex}}{{"}"}}%1~%f %F{{"{"}}{{colors.on_surface.default.hex}}{{"}"}}%#%f '

export FZF_DEFAULT_OPTS="
    --style=full
    --color=fg:{{colors.on_surface.default.hex}},fg+:{{colors.on_surface_variant.default.hex}}
    --color=hl:{{colors.primary.default.hex}},hl+:{{colors.on_primary_container.default.hex}}
    --color=border:{{colors.outline_variant.default.hex}}
    --color=header:{{colors.on_secondary_container.default.hex}}
    --color=gutter:{{colors.surface.default.hex}}
    --color=spinner:{{colors.tertiary.default.hex}},info:{{colors.on_tertiary_container.default.hex}}
    --color=pointer:{{colors.primary_fixed.default.hex}},marker:{{colors.error.default.hex}}
    --color=prompt:{{colors.on_surface_variant.default.hex}},query:{{colors.on_surface.default.hex}}
    --color=preview-fg:{{colors.on_surface.default.hex}},preview-bg:{{colors.surface_container.default.hex}}
    --height=50%
    --layout=reverse
    --border
"
