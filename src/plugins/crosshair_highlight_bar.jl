# plugins/crosshair_highlight_bar

struct CrosshairHighlightBarSettings <: AbstractPluginSettings
    color::String
end

"""
    lwc_vert_line(; kw...) -> LWCPlugin

Adds additional highlighting to the cursor crosshairs.

## Keyword arguments
| Name::Type | Default (Possible values) | Description |
|:-----------|:-------------------------|:------------|
| `color::String` | `"rgba(0, 0, 0, 0.2)"` | Crosshair highlight color. |
"""
function lwc_crosshair_highlight_bar(;
    color::String = "rgba(0, 0, 0, 0.2)",
)::LWCPlugin
    settings = CrosshairHighlightBarSettings(
        color,
    )

    return LWCPlugin(
        "addCrosshairHighlightBar",
        settings
    )
end
